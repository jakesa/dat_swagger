require_relative '../../lib/dat_swagger/utils'

class MockConfig
  include Utils

  def initialize(fields:{})

  end

  def swagger_file_path
    resolve_path '../../spec/data/resultsAPI-swagger.json'
  end

end