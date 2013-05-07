# -*- encoding : utf-8 -*-

class TestsController < ProjectResourceController

  def new
    @test=Test.new
    @test.abstract="测试_#{Time.now.strftime("%Y-%-m-%-d")}"
  end

  def create
    super { save_yield }
  end

  def update
    super { save_yield }
  end

  protected

  def save_yield
    set_associations 'participant', 'user'
    set_associations 'requirement'
    set_associations 'modu'
  end
end
