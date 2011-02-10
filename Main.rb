require "rubygems"
require "gosu"

class Player
  
  attr_reader :x, :y
  
  def initialize(window, startx, starty, image, speed, maxspeed)
    @image = Gosu::Image.new(window, image.to_s, false)
    @burn = Gosu::Sample.new(window, "engine.aif")
    @speed = speed
    @maxspeed = maxspeed
    @playing = @burn.play(0)
    @startx = startx
    @starty = starty
    reset
  end
  
  def chase(target)
    @angle = Gosu::angle(@x,@y,target.x,target.y)
    accelerate
  end
  
  def reset
    @x = @startx
    @y = @starty
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
    
    if @vel_x + offset_x < @maxspeed
      @vel_x += offset_x
    end
    if @vel_y + offset_y < @maxspeed
      @vel_y += offset_y
    end
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
  
protected

  def offset_x
    Gosu::offset_x(@angle, @speed)
  end
  
  def offset_y
    Gosu::offset_y(@angle, @speed)
  end
end



class GameWindow < Gosu::Window
  def initialize
    super(1280,1024,false)
    self.caption = "Will's first spriting with Gosu!"
    
    @player = Player.new(self, 100,100, "forward.png", 0.5, 7.5)
    @enemy = Player.new(self, 400,400, "enemy.png", 0.2, 5)
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
      @enemy.reset
    end
    
    @player.move
    @enemy.chase(@player)
    @enemy.move
  end
  
  def draw
    @player.draw
    @enemy.draw
  end
  
  def button_down(id)
    if id == Gosu::Button::KbEscape
      close
    end
  end
  
end

window = GameWindow.new
window.show