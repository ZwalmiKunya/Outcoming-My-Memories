warn("[FileBasedChaseThemes] amde by Zwalmi Kunya 😊👋🏿")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ChaseThemeFolder = ReplicatedStorage.ClientAssets.Sounds.mus.Game.Round.ChaseThemes
local d: Folder = workspace.Assets.Songs

local chaseThemes = {}
local mainFolder = "ZwalmiKunyasFileBasedChaseThemes"
local s = "/"

ReplicatedStorage.ClientAssets.Sounds.musg.Volume = 1


local function GetChaseThemes()
	for _, CharChaseThemes: Folder in pairs(ChaseThemeFolder:GetChildren()) do
		local directory = mainFolder..s..(CharChaseThemes.Name)

		for i, Skin: Folder in pairs(CharChaseThemes:GetChildren()) do
			local directory = directory..s..(Skin.Name)..s

			if not isfolder(directory) then
				makefolder(directory)
			end

			for m, sound: Sound in pairs(Skin:GetChildren()) do
				local soundId = sound:GetAttribute("PreviousSound") or sound.SoundId
				chaseThemes[soundId] = string.format("%s.mp3", directory..sound.Name)
			end

		end
	end
end

GetChaseThemes()

local function setSound(Sound: Sound)
	if not Sound:IsA("Sound") then return end
	local previousSound = Sound:GetAttribute("PreviousSound")
	local soundId = Sound.SoundId

	local foundDirectory = chaseThemes[previousSound or soundId]
	-- print(previousSound, soundId)

	if foundDirectory then --// i hate this part bro, i am extremely lazy and im keeping it this way
		local asset_id = getcustomasset(foundDirectory)
		local fileExists = isfile(foundDirectory)

		if asset_id and fileExists and asset_id ~= soundId and soundId then
			warn("UPDATING SOUND",Sound.Name,"WITH", foundDirectory)
			-- print(asset_id, soundId) 

			Sound:SetAttribute("PreviousSound", soundId)--soundId)
			Sound.SoundId = asset_id
			Sound.PlaybackRegion = NumberRange.new(0,0)
			Sound.LoopRegion = NumberRange.new(0,0)
			Sound:SetAttribute("Eliminatd", nil)
		end
	elseif not foundDirectory and previousSound then
		print("CHANGING SOUND TO PREVIOUS SOUND ID", foundDirectory)
		Sound.SoundId = previousSound
		Sound:SetAttribute("PreviousSound", nil)
	end
end

local function attemptToUpdateSounds()
	for _, Sound in pairs(workspace.Assets.Songs:GetDescendants()) do
		setSound(sound)
	end
end

if _G.FileBasedChaseThemeUpdateConnection then
	_G.FileBasedChaseThemeUpdateConnection:Disconnect()
	_G.FileBasedChaseThemeUpdateConnection = nil
	warn("[FileBasedChaseThemes] Disconnected previous chase theme updater")
end

print("[FileBasedChaseThemes] Creating chase theme updater connection")

attemptToUpdateSounds()

_G.FileBasedChaseThemeUpdateConnection = d.DescendantAdded:Connect(function(sound)
	warn("sound added attempting to update sounds")
	setSound(Sound)
end)

-- _G.FileBasedChaseThemeUpdateConnection:Disconnect()
