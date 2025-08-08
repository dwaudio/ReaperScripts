-- Get number of project markers and regions
local retval, num_markers, num_regions = reaper.CountProjectMarkers(0)

local start_pos = nil
local stop_pos = nil

-- Loop through all markers and regions
for i = 0, num_markers + num_regions - 1 do
  local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
  if not isrgn then
    if name == "START" then
      start_pos = pos
    elseif name == "STOP" then
      stop_pos = pos
    end
  end
end

-- If both markers found, set time selection
if start_pos and stop_pos then
  -- Ensure the selection is left to right
  if start_pos > stop_pos then
    start_pos, stop_pos = stop_pos, start_pos
  end
  reaper.GetSet_LoopTimeRange(true, false, start_pos, stop_pos, false)
  reaper.ShowMessageBox("Time selection set from START to STOP", "Success", 0)
else
  reaper.ShowMessageBox("START and/or STOP marker not found", "Error", 0)
end
