function component.get(comp_name)
  local comp = component.list(comp_name)()

  if comp then return comp end
  return nil
end

function boot_invoke(adress, method, ...)
  local result = table.pack(pcall(component.invoke, adress, method, ...))
  if not result[1] then
    return nil, result[2]
  else
    return table.unpack(result, 2, result.n)
  end
end

local gpu = component.get("gpu")
local screen = component.get("screen")
local state = 0
local text = "☺ You are an idiot ☺"

if not gpu or not screen then error("You are an idiot!") end
boot_invoke(gpu, "bind", screen)
boot_invoke(gpu, "setResolution", 50,16)

local resx, resy = boot_invoke(gpu, "getResolution")
local startx = resx / 2 - #text / 2
local starty = resy / 2 - #text / 2

function Sleep(timeout)
  local deadline = computer.uptime() + timeout
  repeat
    computer.pullSignal(deadline - computer.uptime())
  until computer.uptime() >= deadline
end

while true do
  if state == 0 then
    boot_invoke(gpu, "setBackground", 0x000000)
    boot_invoke(gpu, "setForeground", 0xffffff)
    state = 1
  else
    boot_invoke(gpu, "setBackground", 0xffffff)
    boot_invoke(gpu, "setForeground", 0x000000)
    state = 0
  end

  boot_invoke(gpu, "fill", 1,1, resx,resy, " ")
  boot_invoke(gpu, "set", startx, starty, text)
  computer.beep()

  Sleep(1)
end
