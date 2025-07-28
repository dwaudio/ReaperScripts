-- @description Delete regions within time selection
-- @version 1.0
-- @author DeltaWavesAudio
-- @about
--   This script deletes any regions that fall partially or entirely within the current time selection.

function delete_regions_in_time_selection()
  local time_sel_start, time_sel_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
  if time_sel_start == time_sel_end then
    reaper.ShowMessageBox("No time selection defined.", "Error", 0)
    return
  end

  local num_markers, num_regions = reaper.CountProjectMarkers(0)
  local total = num_markers + num_regions

  reaper.Undo_BeginBlock()

  for i = total - 1, 0, -1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if isrgn then
      if (rgnend > time_sel_start and pos < time_sel_end) then
        reaper.DeleteProjectMarker(0, markrgnindexnumber, true)
      end
    end
  end

  reaper.Undo_EndBlock("Delete regions in time selection", -1)
end

delete_regions_in_time_selection()
