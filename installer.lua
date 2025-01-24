filePaths = { "/kristify.lua", "/data/config.example.lua", "/data/products.example.lua", "/src/libs/basalt.lua", "/src/libs/inv.lua", "/src/libs/kristly.lua", "/src/backend.lua", "/src/frontend.lua", "/src/init.lua", "/src/logger.lua", "/src/shopsync.lua", "/src/speaker.lua", "/src/utils.lua", "/src/version.txt", "/src/webhook.lua" }


-- split a string
function string:split(delimiter)
  local result = { }
  local from  = 1
  local delim_from, delim_to = string.find( self, delimiter, from  )
  while delim_from do
    table.insert( result, string.sub( self, from , delim_from-1 ) )
    from  = delim_to + 1
    delim_from, delim_to = string.find( self, delimiter, from  )
  end
  table.insert( result, string.sub( self, from  ) )
  return result
end

for file=1, table.getn(filePaths) do
    filePathParts = filePaths[file]:split("/")
    local path = ""
    fileName = filePathParts[table.getn(filePathParts)]
    for i=1, table.getn(filePathParts)-1 do
      path = path .. filePathParts[i] .. "/"
      if fs.exists(path) == false then
        fs.makeDir(path)
      end
    end
    if path == "" then path = "/" end
    error2 = nil
    data, error2, response = http.get("https://gitbucket.fso.ovh/SyntaxNation/Kristify/raw/main"..path..fileName)
    if error2 ~= nil and data == nil then
      print(path..fileName)
      print(error2)
    end
    if data ~= nil then
      fh = fs.open("/kristify"..path..fileName, "w")
      fh.write(data.readAll())
      fh.close()
    end
end

settings.set("kristify.path", "/kristify")