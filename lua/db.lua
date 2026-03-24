local reverseDbPool = {}
local levelDbPool = {}
local fastdictPool = {}

-- 显式从全局获取 Rime 内置类，增加鲁棒性
local ReverseLookup = ReverseLookup
local LevelDb = LevelDb

local fastdict = require "fastdict/fastdict"

local M = {}

function M.openLookup(schemaName)
    -- 检查类是否存在
    if not ReverseLookup then
        error("ReverseLookup class not found! Check your librime-lua version.")
    end
    reverseDbPool[schemaName] = reverseDbPool[schemaName] or ReverseLookup(schemaName)
    return reverseDbPool[schemaName]
end

function M.openDb(dbname, isReadOnly)
    levelDbPool[dbname] = levelDbPool[dbname] or LevelDb(dbname)
    local db = levelDbPool[dbname]
    if db and not db:loaded() then
        -- 修正逻辑：如果是只读模式，调用只读接口
        if isReadOnly then
            db:open_read_only()
        else
            db:open()
        end
    end
    return db
end

-- ... 其他函数保持不变 ...
return M
