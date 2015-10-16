premake.xcode7 = {}

local xcode7 = premake.xcode7

function xcode7.workspace_head()
	_p('<?xml version="1.0" encoding="UTF-8"?>')
	_p('<Workspace')
		_p(1,'version = "1.0">')

end

function xcode7.workspace_tail()
	_p('</Workspace>')
end

function xcode7.workspace_file_ref(prj)

		local projpath = path.getrelative(prj.solution.location, prj.location)
		if projpath == '.' then projpath = '' 
		else projpath = projpath ..'/' 
		end
		_p(1,'<FileRef')
			_p(2,'location = "group:%s">',projpath .. prj.name .. '.xcodeproj')
		_p(1,'</FileRef>')
end

function xcode7.workspace_generate(sln)
	premake.xcode.preparesolution(sln)

	xcode7.workspace_head()

	xcode7.reorderProjects(sln)

	for prj in premake.solution.eachproject(sln) do
		xcode7.workspace_file_ref(prj)
	end
	
	xcode7.workspace_tail()
end

--
-- If a startup project is specified, move it to the front of the project list. 
-- This will make Visual Studio treat it like a startup project.
--

function xcode7.reorderProjects(sln)
	if sln.startproject then
			for i, prj in ipairs(sln.projects) do
				if sln.startproject == prj.name then
					-- Move group tree containing the project to start of group list
					local cur = prj.group
					while cur ~= nil do
						-- Remove group from array
						for j, group in ipairs(sln.groups) do
							if group == cur then
								table.remove(sln.groups, j)
								break
							end
						end

						-- Add back at start
						table.insert(sln.groups, 1, cur)
						cur = cur.parent
					end
						-- Move the project itself to start
					table.remove(sln.projects, i)
					table.insert(sln.projects, 1, prj)
					break
				end
			end
	end
end




