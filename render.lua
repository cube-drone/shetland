module(..., package.seeall)

function init()
   local clr = config.window_clear_color
   MOAIGfxDevice.setClearColor(1, 1, 1, 1)

   for idx,layer in ipairs(layers:getLayers()) do
      log.info("render", "Pushing layer " .. idx)
      MOAIRenderMgr:pushRenderPass(layers:get(idx))
   end
end
