local VolumetricMaxUnpooling, parent = torch.class('nn.VolumetricMaxUnpooling', 'nn.Module')

function VolumetricMaxUnpooling:__init(poolingModule)
  parent.__init(self)
  assert(torch.type(poolingModule)=='nn.VolumetricMaxPooling', 'Argument must be a nn.VolumetricMaxPooling module')
  assert(poolingModule.kT==poolingModule.dT and poolingModule.kH==poolingModule.dH and poolingModule.kW==poolingModule.dW, "The size of pooling module's kernel must be equal to its stride")
  self.pooling = poolingModule

  poolingModule.updateOutput = function(pool, input)
    local dims = input:dim()
    pool.itime = input:size(dims-2)
    pool.iheight = input:size(dims-1)
    pool.iwidth = input:size(dims)
    return nn.VolumetricMaxPooling.updateOutput(pool, input)
  end
end

function VolumetricMaxUnpooling:setParams()
  self.indices = self.pooling.indices
  self.otime = self.pooling.itime
  self.oheight = self.pooling.iheight
  self.owidth = self.pooling.iwidth
  self.dT = self.pooling.dT
  self.dH = self.pooling.dH
  self.dW = self.pooling.dW
  self.padT = self.pooling.padT
  self.padH = self.pooling.padH
  self.padW = self.pooling.padW
end

function VolumetricMaxUnpooling:updateOutput(input)
  self:setParams()
  input.nn.VolumetricMaxUnpooling_updateOutput(self, input)
  return self.output
end

function VolumetricMaxUnpooling:updateGradInput(input, gradOutput)
  self:setParams()
  input.nn.VolumetricMaxUnpooling_updateGradInput(self, input, gradOutput)
  return self.gradInput
end

function VolumetricMaxUnpooling:empty()
   self.gradInput:resize()
   self.gradInput:storage():resize(0)
   self.output:resize()
   self.output:storage():resize(0)
end

function VolumetricMaxUnpooling:__tostring__()
   return 'nn.VolumetricMaxUnpooling associated to '..tostring(self.pooling)
end
