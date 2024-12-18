#! /usr/bin/env nix-shell
#! nix-shell -i bash -p i3 jq json2yaml bat

select_cmd="
walk(
if type == \"object\" and has(\"window\") then 
	if has(\"window\") then 
		if .window == null then
			if (.nodes | length) > 0 and (.floating_nodes | length) > 0 then
				{nodes: .nodes, floating_nodes: .floating_nodes, layout: .layout, name: .name}
			elif (.nodes | length) > 0 then
				{nodes: .nodes, layout: .layout, name: .name}
			elif (.floating_nodes | length) > 0 then
				{floating_nodes: .floating_nodes, layout: .layout, name: .name}
			else
				empty
			end
		else
			.window_properties.instance
		end
	else 
		{nodes: .nodes, floating_nodes: .floating_nodes}
	end 
else 
	.
end
)
"
i3-msg -t "get_tree" | jq "$select_cmd" | json2yaml | bat --language yaml --style snip
