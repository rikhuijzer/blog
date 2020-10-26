# This file was generated, do not modify it. # hide
graduates = # hide
@from i in results begin
  @where i.pass == true
  @orderby ascending(i.name)
  @select {i.name}
  @collect DataFrame
end
write_csv("graduates", graduates) # hide