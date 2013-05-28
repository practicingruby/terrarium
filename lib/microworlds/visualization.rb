module Microworlds
  class Visualization
    include Java

    import java.awt.Color
    import java.awt.Graphics
    import java.awt.BasicStroke
    import java.awt.Dimension
    import java.awt.Polygon

    import java.awt.image.BufferedImage
    import javax.swing.JPanel
    import javax.swing.JFrame

    class Panel < JPanel
      attr_accessor :interface, :simulator

      def paint(g)
        return unless simulator

        interface.render(g, simulator)
      end
    end

    SCALE = 10

    def initialize
      @panel = Panel.new
      @panel.interface = self
      
      @panel.setPreferredSize(Dimension.new(SCALE * Simulator::DIMENSIONS,
                                           SCALE * Simulator::DIMENSIONS))
      frame = JFrame.new
      frame.add(@panel)
      frame.pack
      frame.show
    end

    def update(simulator)
      @panel.simulator = simulator
      @panel.repaint
    end

    def fill_cell(g, x, y, c)
      g.setColor(c)
      g.fillRect(x * SCALE, y * SCALE, SCALE, SCALE)
    end

    def render(g, sim)
      dim = Simulator::DIMENSIONS

      img = BufferedImage.new(SCALE * dim, 
                              SCALE * dim,
                              BufferedImage::TYPE_INT_ARGB)

      bg  = img.getGraphics

      bg.setColor(Color.white)
      bg.fillRect(0,0, img.getWidth, img.getHeight)


      sim.world.each_patch do |patch|
        color = Color.send(patch.color)

        fill_cell(bg, patch.xpos, patch.ypos, color)
      end

      sim.world.each_creature do |creature|
        color = Color.send(creature[:color])

        bg.setColor(color)
        bg.fillOval(creature[:xpos] * SCALE, creature[:ypos] * SCALE, 
                                      SCALE, SCALE)
       
        bg.fillOval(creature[:xpos] * SCALE + SCALE*0.50, 
                    creature[:ypos] * SCALE + SCALE*0.25,
                    SCALE * 0.75, SCALE * 0.75)

        creature[:xpos] = (creature[:xpos] + 1) % 
                          Simulator::DIMENSIONS

        creature[:ypos] = (creature[:ypos] + rand(-1..1)) % 
                          Simulator::DIMENSIONS

        sim.world.update_patch(creature[:xpos], creature[:ypos]) { |patch| 
          patch.set_patch_color :white 
        }
      end


      g.drawImage(img, 0, 0, nil)
      bg.dispose
    end
  end
end
