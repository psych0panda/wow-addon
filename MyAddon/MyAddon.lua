-- Создаем фрейм для отображения истории чата
local chatHistoryFrame = CreateFrame("Frame", "ChatHistoryFrame", UIParent, "BasicFrameTemplateWithInset")
chatHistoryFrame:SetSize(500, 300) -- Размер окна
chatHistoryFrame:SetPoint("CENTER") -- Позиция окна
chatHistoryFrame:Hide() -- Скрываем окно по умолчанию

-- Заголовок окна
chatHistoryFrame.title = chatHistoryFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
chatHistoryFrame.title:SetPoint("CENTER", chatHistoryFrame.TitleBg, "CENTER", 0, 0)
chatHistoryFrame.title:SetText("История чата")

-- Поле для отображения текста
local scrollFrame = CreateFrame("ScrollFrame", nil, chatHistoryFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 10, -30)
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

local editBox = CreateFrame("EditBox", nil, scrollFrame)
editBox:SetMultiLine(true)
editBox:SetFontObject("ChatFontNormal")
editBox:SetWidth(450)
editBox:SetAutoFocus(false)
editBox:SetScript("OnEscapePressed", function() editBox:ClearFocus() end)
scrollFrame:SetScrollChild(editBox)


-- Событие для записи сообщений в историю
local chatHistory = {}
local frame = CreateFrame("Frame")

-- Регистрируем все события, связанные с чатом
local chatEvents = {
    "CHAT_MSG_CHANNEL",
    "CHAT_MSG_SAY",
    "CHAT_MSG_YELL",
    "CHAT_MSG_WHISPER",
    "CHAT_MSG_PARTY",
    "CHAT_MSG_PARTY_LEADER",
    "CHAT_MSG_RAID",
    "CHAT_MSG_RAID_LEADER",
    "CHAT_MSG_RAID_WARNING",
    "CHAT_MSG_INSTANCE_CHAT",
    "CHAT_MSG_INSTANCE_CHAT_LEADER",
    "CHAT_MSG_GUILD",
    "CHAT_MSG_OFFICER",
    "CHAT_MSG_EMOTE",
    "CHAT_MSG_TEXT_EMOTE",
    "CHAT_MSG_SYSTEM",
    "CHAT_MSG_MONSTER_SAY",
    "CHAT_MSG_MONSTER_YELL",
    "CHAT_MSG_MONSTER_EMOTE",
    "CHAT_MSG_MONSTER_WHISPER",
    "CHAT_MSG_MONSTER_PARTY",
    "CHAT_MSG_ACHIEVEMENT",
    "CHAT_MSG_LOOT",
    "CHAT_MSG_MONEY",
    "CHAT_MSG_BG_SYSTEM_NEUTRAL",
    "CHAT_MSG_BG_SYSTEM_ALLIANCE",
    "CHAT_MSG_BG_SYSTEM_HORDE",
    "CHAT_MSG_BN_WHISPER",
    "CHAT_MSG_BN_WHISPER_INFORM",
    "CHAT_MSG_BN_INLINE_TOAST_ALERT",
    "CHAT_MSG_BN_INLINE_TOAST_BROADCAST",
    "CHAT_MSG_BN_INLINE_TOAST_BROADCAST_INFORM",
    "CHAT_MSG_BN_INLINE_TOAST_CONVERSATION",
    "CHAT_MSG_TRADESKILLS",
    "CHAT_MSG_IGNORED",
    "CHAT_MSG_FILTERED",
    "CHAT_MSG_RESTRICTED",
    "CHAT_MSG_TARGETICONS",
    "CHAT_MSG_CHANNEL_JOIN",
    "CHAT_MSG_CHANNEL_LEAVE",
    "CHAT_MSG_CHANNEL_NOTICE",
    "CHAT_MSG_CHANNEL_NOTICE_USER",
}

-- Регистрируем все события в фрейме
for _, event in ipairs(chatEvents) do
    frame:RegisterEvent(event)
end

-- Обработчик событий с форматированием текста
frame:SetScript("OnEvent", function(self, event, message, sender)
    local timeStamp = date("%H:%M:%S") -- Время сообщения
    local formattedMessage = string.format("|cff00ff00[%s]|r |cffffd700%s|r: %s", timeStamp, sender or "Система", message)
    table.insert(chatHistory, formattedMessage)
    if #chatHistory > 100 then
        table.remove(chatHistory, 1) -- Ограничиваем историю до 100 сообщений
    end
end)

-- Команда для открытия окна с отступами
SLASH_CHATHISTORY1 = "/chathistory"
SlashCmdList["CHATHISTORY"] = function()
    local fullText = table.concat(chatHistory, "\n\n") -- Разделяем сообщения пустой строкой
    editBox:SetText(fullText)
    editBox:SetTextInsets(10, 10, 10, 10) -- Отступы: слева, справа, сверху, снизу
    editBox:HighlightText(0, 0) -- Снимаем выделение текста
    chatHistoryFrame:Show()
end