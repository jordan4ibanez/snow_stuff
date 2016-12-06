
minetest.register_entity("snowballs:snowball", {
    physical = true,
    collide_with_objects = true,
    collisionbox = {-0.1,-0.1,-0.1, 0.1,0.1,0.},
    visual = "sprite",
    visual_size = {x=1, y=1},
    textures={"default_snowball.png"},
    makes_footstep_sound = false,
    oldvel = {x=0,y=0,z=0},
    on_activate = function(self)
		
		self.object:setacceleration({x=0,y=-10,z=0})
    end,
    
    on_step = function(self,dtime)
		local vel = self.object:getvelocity()

		
		
		
		if (vel.x == 0 and self.oldvel.x ~=0) or (vel.z == 0 and self.oldvel.z ~=0) or (vel.y == 0 and self.oldvel.y ~=0) then
			local pos  = self.object:getpos()
			for _,player in ipairs(minetest.env:get_objects_inside_radius(pos, 2)) do
				if player:is_player() then
					player:punch(self.object, 1.0,  {
						full_punch_interval=1.0,
						damage_groups = {fleshy=1}
					}, vec)
				end
			end
			
			minetest.add_particlespawner({
				amount = 30,
				time = 0.1,
				minpos = pos,
				maxpos = pos,
				minvel = {x=-3, y=3, z=-3},
				maxvel = {x=3, y=5, z=-3},
				minacc = {x=0, y=-10, z=0},
				maxacc = {x=0, y=-10, z=0},
				minexptime = 1,
				maxexptime = 2,
				minsize = 1,
				maxsize = 1,
				collisiondetection = true,
				vertical = false,
				texture = "snow_flakes_snowball.png",
			})
			self.object:remove()
		end
		
		self.oldvel = vel		
    end,
})
