AutoTrackQuests = {}
AutoTrackQuests.Frame = CreateFrame("Frame")
AutoTrackQuests.Frame:SetScript("OnEvent", function(self, event, ...)
	if event == "QUEST_ACCEPTED" then
		local qindex = ...
		local num_objectives = GetNumQuestLeaderBoards(qindex)
		
		-- Don't track an untrackable quest (no objectives)
		if num_objectives > 0 then
			-- If we're tracking 5 or more quests, keep untracking the oldest ones until we're at 4 so we can track the new one
			while GetNumQuestWatches() >= 5 do
				RemoveQuestWatch(GetQuestIndexForWatch(1))
				QuestWatch_Update()
			end
			
			AddQuestWatch(qindex)
		end
	end
end)
AutoTrackQuests.Frame:RegisterEvent("QUEST_ACCEPTED")