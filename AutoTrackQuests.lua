AutoTrackQuests = {}
AutoTrackQuests.Frame = CreateFrame("Frame")
AutoTrackQuests.Frame:SetScript("OnEvent", function(self, event, ...)
	if event == "QUEST_ACCEPTED" then
		local qindex = ...
		AutoTrackQuests.WatchQuest(qindex)
		
	elseif event == "QUEST_WATCH_UPDATE" then
		-- If someone's using this AddOn, they probably want things auto-tracked anyway, so don't bother checking
		--if GetCVar("autoQuestWatch") == "0" then return end -- Don't do the auto-watching on objective stuff if it's disabled in interface options
		local qindex = ...
		AutoTrackQuests.WatchQuest(qindex)
	
	elseif event == "ADDON_LOADED" then
		local addon_name = ...
		if addon_name == "AutoTrackQuests" then
			if not AutoTrackQuestsDB then
				AutoTrackQuestsDB = {watch_on_objective = true}
			end
			
			AutoTrackQuests.CreateOptionsFrame()
		end
	end
end)
AutoTrackQuests.Frame:RegisterEvent("QUEST_ACCEPTED")
AutoTrackQuests.Frame:RegisterEvent("QUEST_WATCH_UPDATE")
AutoTrackQuests.Frame:RegisterEvent("ADDON_LOADED")

function AutoTrackQuests.WatchQuest(qindex)
	local num_objectives = GetNumQuestLeaderBoards(qindex)
	
	if num_objectives == 0 then return end    -- Don't watch an untrackable quest (no objectives)
	if IsQuestWatched(qindex) then return end -- Don't watch an already-watched quest
	
	-- If we're tracking 5 or more quests, keep untracking the oldest ones until we're at 4 so we can track the new one
	while GetNumQuestWatches() >= 5 do
		RemoveQuestWatch(GetQuestIndexForWatch(1))
		QuestWatch_Update()
	end
	
	AddQuestWatch(qindex)
end

SlashCmdList['AUTOTRACKQUESTS_SLASHCMD'] = function(msg)
	-- Twice, since the first call only succeeds in opening the options panel itself; the second call opens the correct category
	InterfaceOptionsFrame_OpenToCategory(AutoTrackQuests.options)
	InterfaceOptionsFrame_OpenToCategory(AutoTrackQuests.options)
end
SLASH_AUTOTRACKQUESTS_SLASHCMD1 = '/atq'
SLASH_AUTOTRACKQUESTS_SLASHCMD2 = '/autotrackquests'


function AutoTrackQuests:CreateOptionsFrame()		-- Constructs the options frame
	AutoTrackQuests.options = CreateFrame("Frame", "AutoTrackQuestsOptions")
	
	local title = AutoTrackQuests.options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetFont("Fonts\\FRIZQT__.TTF", 16)
	title:SetText("Auto Track Quests")
	title:SetPoint("TOPLEFT", 16, -16)
	
	local subtitle = AutoTrackQuests.options:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	subtitle:SetFont("Fonts\\FRIZQT__.TTF", 10)
	subtitle:SetText("Version " .. GetAddOnMetadata("AutoTrackQuests","Version"))
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 4, -8)
	
	local cb_watch_on_objective = CreateFrame("CheckButton", "ATQWatchOnObjective", AutoTrackQuests.options, "UICheckButtonTemplate")
	cb_watch_on_objective:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", -3, -20)
	ATQWatchOnObjectiveText:SetJustifyH("LEFT")
	ATQWatchOnObjectiveText:SetText("When progressing an unwatched quest and the quest tracker is full, |r|nunwatch the oldest quest to make room")
	cb_watch_on_objective:SetScript("OnShow", function(self) self:SetChecked(AutoTrackQuestsDB.watch_on_objective) end)
	cb_watch_on_objective:SetScript("OnClick", function(self) AutoTrackQuestsDB.watch_on_objective = self:GetChecked() end)
	cb_watch_on_objective:SetChecked(AutoTrackQuestsDB.watch_on_objective)
	
	AutoTrackQuests.options.name = "Auto Track Quests"
	InterfaceOptions_AddCategory(AutoTrackQuests.options)
end