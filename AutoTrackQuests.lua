AutoTrackQuests = {}
AutoTrackQuests.Frame = CreateFrame("Frame")
AutoTrackQuests.Frame:SetScript("OnEvent", function(self, event, ...)
	if event == "QUEST_ACCEPTED" then
		local qindex = ...
		AddQuestWatch(qindex)
	end
end)
AutoTrackQuests.Frame:RegisterEvent("QUEST_ACCEPTED")