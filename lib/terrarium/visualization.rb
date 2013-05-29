module Terrarium
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

    SCALE = 12

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

        x = creature[:xpos]
        y = creature[:ypos]

        bg.setColor(color.darker)
        bg.fillOval(x * SCALE, y * SCALE, SCALE, SCALE)
       

        angle = creature[:heading] * Math::PI / 180

        hx = (x * SCALE) + (SCALE * 0.5 * Math.cos(angle))
        hy = (y * SCALE) + (SCALE * 0.5 * Math.sin(angle))

        bg.setColor(color)
        bg.fillOval(hx + SCALE*0.25, hy + SCALE*0.25, SCALE*0.5, SCALE*0.5)


        sim.world.update_patch(x, y) { |patch| 
          patch.set_patch_color :white 
        }
      end


      g.drawImage(img, 0, 0, nil)
      bg.dispose
    end
  end
end
