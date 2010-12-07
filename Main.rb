require "rubygems"
require "gosu"

class Player
  def initialize(window)
    if FileTest.exists? "forward.png"
      @image = Gosu::Image.new(window, "forward.png", false)
    else
      puts "forward.png is missing!"
    end
    if FileTest.exists? "engine.aif"
      @burn = Gosu::Sample.new(window, "engine.aif")
    else
      puts "engine.aif is missing!"
    end
    
    @playing = @burn.play(0)
    @x = 100.0
    @y = 100.0
    @angle = 0.0
    @vel_x = 0.0
    @vel_y = 0.0
  end
  
  def reset
    @x = 100.0
    @y = 100.0
    @angle = 0.0
    @vel_x = 0.0
    @vel_y = 0.0
  end
  
  def turn_left
    @angle -= 4.5
  end
  
  def turn_right
    @angle += 4.5
  end
  
  def move
    @x += @vel_x
    @y += @vel_y
  end
  
  def accelerate
    unless @playing.playing?
      @playing = @burn.play
    end
    @vel_x += Gosu::offset_x(@angle, 0.5)
    @vel_y += Gosu::offset_y(@angle, 0.5)
  end
  
  def deccelerate
    if @vel_x - Gosu::offset_x(@angle, 0.5) > 0
      @vel_x -= Gosu::offset_x(@angle, 0.5)
    end
    if @vel_y - Gosu::offset_x(@angle, 0.5) > 0
      @vel_y -= Gosu::offset_x(@angle, 0.5)
    end
  end
  
  def draw
    @image.draw_rot(@x, @y, 1, @angle + 90)
  end
end



class GameWindow < Gosu::Window
  def initialize
    super(1280,1024,false)
    self.caption = "Will's first spriting with Gosu!"
    
    @player = Player.new(self)
  end
  
  
  def update
    if button_down? Gosu::Button::KbLeft or button_down? Gosu::Button::GpLeft then
      @player.turn_left
    end
    if button_down? Gosu::Button::KbRight or button_down? Gosu::Button::GpRight then
      @player.turn_right
    end
    if button_down? Gosu::Button::KbUp or button_down? Gosu::Button::GpButton0 then
      @player.accelerate
    end
    if button_down? Gosu::Button::KbDown
      @player.deccelerate
    end
    if button_down? Gosu::Button::KbSpace then
      @player.reset
    end
    
    @player.move
  end
  
  def draw
    @player.draw
  end
  
  def button_down(id)
    if id == Gosu::Button::KbEscape
      close
    end
  end
  
end

window = GameWindow.new
window.show


