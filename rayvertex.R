

library(rayvertex)

job::job(
  
text3d_mesh("A long time ago in a rayverse far,",color=c(75, 213, 238)/255) %>% 
  add_shape(text3d_mesh("far, away...",color=c(75, 213, 238)/255,position=c(-5,-1,0))) %>% 
  rasterize_scene(fov=120,lookat=c(0,-0.5,0),lookfrom=c(0,-0.5,5),
                  filename="start")

for(i in 1:(24*6)) {
  png::readPNG(glue::glue("start.png")) %>% 
    png::writePNG(glue::glue("starwarsvertex{i}.png"))
}

dissolveval = c(seq(1,0,length.out=12),rep(0,24))
for(i in 1:36) {
  text3d_mesh("A long time ago in a rayverse far,",color=c(75, 213, 238)/255) %>% 
    add_shape(text3d_mesh("far, away...",color=c(75, 213, 238)/255,position=c(-5.2,-1,0))) %>% 
    change_material(dissolve = dissolveval[i]) %>% 
    rasterize_scene(fov=120,lookat=c(0,-0.5,0),lookfrom=c(0,-0.5,5),
                    filename=glue::glue("starwarsvertex{i+144}.png"))
}


dval = c(rep(1,(240-24*3)),c(seq(1,0,length.out=24)))

for(i in 168:(240+24-24*3)) {
  text3d_mesh("PACKAGE",color=c(229,177,58)/255,position=c(0,-0.5,4.9-i/40)) %>% 
    add_shape(text3d_mesh("UPDATE",color=c(229,177,58)/255,position=c(0,-1.2,4.9-i/40))) %>% 
    change_material(dissolve = dval[i]) %>% 
    rasterize_scene(fov=120,lookat=c(0,-0.5,0),lookfrom=c(0,-0.5,5),
                    filename=glue::glue("starwarsvertex{i+180}.png"),
    )
}

ts = 30
ov = 2.5
for(i in seq(210,1000,by=1)) {
  text3d_mesh("Rayvertex 0.2.0",color=c(229,177,58)/255,position=c(0,-2.5,4.9-i/30 + ov), orientation = "xz",angle=c(0,180,0)) %>% 
    add_shape(text3d_mesh("A New Update",text_height=1.5,color=c(229,177,58)/255,position=c(0,-2.5,4.9-(i-40)/30 + ov), orientation = "xz",angle=c(0,180,0))) %>%
    add_shape(text3d_mesh("Turmoil  has  engulfed  the",text_height=1,color=c(229,177,58)/255,position=c(0,-2.5,4.9-(i-100)/30 + ov), orientation = "xz",angle=c(0,180,0))) %>% 
    add_shape(text3d_mesh("rayverse. Wait, that doesn't",text_height=1,color=c(229,177,58)/255,position=c(0,-2.5,4.9-(i-100-ts)/30 + ov), orientation = "xz",angle=c(0,180,0))) %>% 
    add_shape(text3d_mesh("sound right. Oh, wrong text.",text_height=1,color=c(229,177,58)/255,position=c(0,-2.5,4.9-(i-100-ts*2)/30 + ov), orientation = "xz",angle=c(0,180,0))) %>% 
    add_shape(text3d_mesh("Here it is. 3D text support ",text_height=1,color=c(229,177,58)/255,position=c(0,-2.5,4.9-(i-100-ts*3)/30 + ov), orientation = "xz",angle=c(0,180,0))) %>% 
    add_shape(text3d_mesh("and 3D PLY meshes have ",text_height=1,color=c(229,177,58)/255,position=c(0,-2.5,4.9-(i-100-ts*4)/30 + ov), orientation = "xz",angle=c(0,180,0))) %>% 
    add_shape(text3d_mesh("been added to rayvertex!    ",text_height=1,color=c(229,177,58)/255,position=c(0,-2.5,4.9-(i-100-ts*5)/30 + ov), orientation = "xz",angle=c(0,180,0))) %>% 
    add_shape(text3d_mesh("That's it. That's the text. :)",text_height=1,color=c(229,177,58)/255,position=c(0,-2.5,4.9-(i-100-ts*10)/30 + ov), orientation = "xz",angle=c(0,180,0))) %>% 
    rasterize_scene(fov=80,lookat=c(0,-0.5,0),lookfrom=c(0,5,10),
                    filename=glue::glue("starwarsvertex{i+372}"),
    )
}

)