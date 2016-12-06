
minetest.register_entity("snowman:snowman", {
    physical = true,
    collide_with_objects = false,
    collisionbox = {-0.5,-1,-0.5, 0.5,0.75,0.5},
    visual = "mesh",
    mesh   = "snowman.x",
    visual_size = {x=1, y=1},
    textures={"default_snow.png","default_snow.png","default_snow.png","default_dirt.png","default_dirt.png","default_dirt.png","default_dirt.png","default_dirt.png","default_dirt.png"},
    makes_footstep_sound = false,
    yaw = 0,
    owner = "singleplayer",
    on_activate = function(self,dtime)
		self.object:set_animation({x=90,y=90}, 0, 0, false)
		self.object:setacceleration({x=0,y=-10,z=0})
		self.object:setvelocity({x=math.random(-3,3),y=math.random(-3,3),z=math.random(-3,3)})
    end,
    
    on_step = function(self,dtime)
		local pos1 = self.object:getpos()
		local pos2 = minetest.get_player_by_name(self.owner):getpos()
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
		
		print(pitch)
		
		self.object:set_animation({x=pitch,y=pitch}, 0, 0, false)
		
		if  minetest.get_player_by_name(self.owner):get_player_control().LMB == true then
			self.object:setvelocity(vec)
		end
    end,
})
