require File.expand_path('../test_helper', __FILE__)

class ViewTest < Test::Unit::TestCase
  def compactor(path)
    Vim::Todo::View::PathCompactor.new(path)
  end

  test 'does not compact segments if the path fits the given width' do
    assert_equal 'foo/bar/baz/buz', compactor('foo/bar/baz/buz').compact(15)
  end

  test 'compacts segments if the path does not fit the given width (1)' do
    assert_equal 'foo/../baz/buz', compactor('foo/bar/baz/buz').compact(14)
  end

  test 'compacts segments if the path does not fit the given width (2)' do
    assert_equal 'foo/../buz', compactor('foo/bar/baz/buz').compact(10)
  end
end
