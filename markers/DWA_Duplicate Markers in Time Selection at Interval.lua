-- Duplicate markers in time selection at the same interval

local retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
local ts_start, ts_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
local interval = ts_end - ts_start

if interval <= 0 then
  reaper.ShowMessageBox("Invalid time selection.", "Error", 0)
  return
end

-- Ask how many times to duplicate
local ret, input = reaper.GetUserInputs("Duplicate Markers", 1, "Number of repetitions:", "3")
if not ret then return end
local repetitions = tonumber(input)

if not repetitions or repetitions < 1 then
  reaper.ShowMessageBox("Invalid number of repetitions.", "Error", 0)
  return
end

-- Store markers inside time selection
local markers_to_duplicate = {}

for i = 0, num_markers + num_regions - 1 do
  local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
  if not isrgn and pos >= ts_start and pos <= ts_end then
    table.insert(markers_to_duplicate, {pos = pos, name = name})
  end
end

reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

for i = 1, repetitions do
  for _, marker in ipairs(markers_to_duplicate) do
    local new_pos = marker.pos + interval * i
    reaper.AddProjectMarker(0, false, new_pos, 0, marker.name, -1)
  end
end

reaper.PreventUIRefresh(-1)
reaper.UpdateArrange()
reaper.Undo_EndBlock("Duplicate Markers in Time Selection", -1)
