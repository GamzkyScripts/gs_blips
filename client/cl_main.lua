local createdBlips = {}
local blipData = {}
local currentBlip = nil
local isOverlayOpen = false
local blipIndex = 0

function CreateBlip(params)
    local invokingResource = GetInvokingResource()

    -- Validate params
    if not params.coords then
        print(('^1[%s] Error while creating blip: coords is required'):format(invokingResource))
        return
    end
    if not params.sprite then
        print(('^1[%s] Error while creating blip: sprite is required'):format(invokingResource))
        return
    end
    if not params.label then
        print(('^1[%s] Error while creating blip: label is required'):format(invokingResource))
        return
    end

    local coords = ParseCoords(params.coords)
    local sprite = params.sprite
    local scale = params.scale or 1.0
    local color = params.color or 0
    local label = params.label
    local data = params.data or { title = label }
    local display = params.display or 4

    local blipHandle = AddBlipForCoord(coords.x, coords.y, coords.z)

    SetBlipSprite(blipHandle, sprite)
    SetBlipScale(blipHandle, scale)
    SetBlipColour(blipHandle, color)
    SetBlipDisplay(blipHandle, display)
    SetBlipAsShortRange(blipHandle, true)
    SetBlipHighDetail(blipHandle, true)
    SetBlipAsMissionCreatorBlip(blipHandle, true)

    blipIndex = blipIndex + 1
    local blipTextEntry = 'GS_BLIP_' .. blipIndex
    AddTextEntry(blipTextEntry, label)
    BeginTextCommandSetBlipName(blipTextEntry)
    AddTextComponentSubstringPlayerName('me')
    EndTextCommandSetBlipName(blipHandle)

    if data then
        blipData[blipHandle] = data
    end

    createdBlips[invokingResource] = createdBlips[invokingResource] or {}
    table.insert(createdBlips[invokingResource], blipHandle)

    local blipObject = {
        handle = blipHandle,

        setData = function(newData)
            blipData[blipHandle] = newData
            UpdateBlipOverlay(blipHandle)
        end,

        setTitle = function(title)
            blipData[blipHandle].title = title
            UpdateBlipOverlay(blipHandle)
        end,

        setDescription = function(description)
            blipData[blipHandle].description = description
            UpdateBlipOverlay(blipHandle)
        end,

        setDisplayHandler = function(fn)
            blipData[blipHandle].onDisplay = fn
        end,

        delete = function()
            DeleteBlip(blipHandle)
        end,
    }

    return blipObject
end

function DeleteBlip(blipHandle)
    if blipData[blipHandle] then
        blipData[blipHandle] = nil
    end
    if DoesBlipExist(blipHandle) then
        RemoveBlip(blipHandle)
    end
end

function GetBlip(blipHandle)
    return blipData[blipHandle]
end

function ParseCoords(input)
    local inputType = type(input)

    -- Convert table to vector3
    if (inputType == 'table') then
        if input.x and input.y and input.z then
            return vector3(input.x, input.y, input.z)
        else
            return vector3(input[1], input[2], input[3])
        end
    end

    return input
end

CreateThread(function()
    while true do
        Wait(100)
        if IsFrontendReadyForControl() then
            if IsHoveringOverMissionCreatorBlip() then
                local blipHandle = GetNewSelectedMissionCreatorBlip()
                if DoesBlipExist(blipHandle) then
                    if currentBlip ~= blipHandle then
                        currentBlip = blipHandle
                        if blipData[blipHandle] then
                            ShowBlipOverlay(blipHandle)
                            if blipData[blipHandle].onDisplay then
                                blipData[blipHandle].onDisplay()
                            end
                        else
                            HideBlipOverlay()
                        end
                    end
                end
            else
                if currentBlip then currentBlip = nil end
                if isOverlayOpen then HideBlipOverlay() end
            end
        end
    end
end)

AddEventHandler('onClientResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then return end

    if createdBlips[resourceName] then
        -- Delete blips created by this resource
        for i = 1, #createdBlips[resourceName] do
            local blipHandle = createdBlips[resourceName][i]
            if DoesBlipExist(blipHandle) then
                RemoveBlip(blipHandle)
            end
        end

        createdBlips[resourceName] = nil
    end
end)

function ShowBlipOverlay(blipHandle)
    isOverlayOpen = true
    SendNUIMessage({ action = 'show', data = blipData[blipHandle] })
end

function HideBlipOverlay()
    isOverlayOpen = false
    SendNUIMessage({ action = 'hide' })
end

function UpdateBlipOverlay(blip)
    SendNUIMessage({ action = 'update', data = blipData[blip] })
end

-- Exports
exports('CreateBlip', CreateBlip)
exports('DeleteBlip', DeleteBlip)
exports('GetBlip', GetBlip)
