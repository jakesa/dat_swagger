module Utils
  def resolve_path(path)
    File.absolute_path( File.join( __dir__,path))
  end
end