
minetest.register_entity("snowman:snowman", {
    physical = true,
    collide_with_objects = false,
    collisionbox = {-0.5,-1,-0.5, 0.5,0.5,0.5},
    visual = "mesh",
    mesh   = "snowman.x",
    visual_size = {x=1, y=1},
    textures={"default_snow.png","default_snow.png","default_snow.png","default_dirt.png","default_dirt.png","default_dirt.png","default_dirt.png","default_dirt.png","default_dirt.png"},
    makes_footstep_sound = false,
    yaw = 0,
    owner = "singleplayer",
    stepheight = 2,
    attack_timer = 0,
    on_activate = function(self,dtime)
		self.object:set_animation({x=90,y=90}, 0, 0, false)
		self.object:setacceleration({x=0,y=-10,z=0})
		self.object:setvelocity({x=math.random(-3,3),y=math.random(-3,3),z=math.random(-3,3)})
    end,
    round = function(what, precision)
	   return math.floor(what*math.pow(10,precision)+0.5) / math.pow(10,precision)
	end,
    on_step = function(self,dtime)
		for _,object in ipairs(minetest.env:get_objects_inside_radius(self.object:getpos(), 6)) do
			self.attack_timer = self.attack_timer + dtime
			if object:is_player() then
				local pos1 = self.object:getpos()
				local pos2 = object:getpos()
				pos2.y = pos2.y + 1
				local vec = {}
				vec.y = pos1.y - pos2.y
				vec.x = pos1.x - pos2.x
				vec.z = pos1.z - pos2.z
				
				self.yaw = math.atan(vec.z/vec.x)+math.pi/2
				
				
				if pos1.x > pos2.x then
					self.yaw = self.yaw+math.pi
				end
				self.object:setyaw(self.yaw)
				
				
				--size
				local distance = vector.distance(pos1, pos2) * 2
				
				--roll
				local pitch = math.atan2(math.sqrt(vec.z * vec.z + vec.x * vec.x), vec.y)
						
				pitch = ((pitch/math.pi)*180)+90
				
				self.object:set_animation({x=pitch,y=pitch}, 0, 0, false)
				
				--make snowmen purposely dumb so you have to make snowmen "turrets"
				
				local x = self.round(self.object:getvelocity().x, 2)
				local z = self.round(self.object:getvelocity().z, 2)
				
				local goal_x = self.round(math.sin(self.yaw) * -1, 2)*-3
				local goal_z = self.round(math.cos(self.yaw), 2)*-3
					
				self.object:setvelocity({x=goal_x,y=-10,z=goal_z})
				
				--shoot snowballs
				if self.attack_timer >= 2 then
					self.attack_timer = 0
					local snowball = minetest.add_entity(pos1, "snowballs:snowball")
					
					snowball:setvelocity({x=self.round(math.sin(self.yaw)*(distance*3), 2),y=vec.y * (distance*3),z=self.round(math.cos(self.yaw)*-1*(distance*3), 2)})
					
				end
				--stop it from getting too close
				for _,player in ipairs(minetest.env:get_objects_inside_radius(self.object:getpos(), 2)) do
					if player:is_player() then
						self.object:setvelocity({x=0,y=-10,z=0})
					end
				end
			end
		end
		
    end,
})
