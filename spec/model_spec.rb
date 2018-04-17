require_relative 'spec_helper'

describe DATSwagger::Models do

  before(:all) do
    @swag = DATSwagger.new('./spec/resultsAPI-swagger.json')
  end

  it 'generates a model based on the swagger file' do
    expect(defined?(DATSwagger::Models::TestRunResult)).not_to be_nil
  end

  it 'should have the expected defined properties' do
    model = DATSwagger::Models::TestRunResult.new
    properties = [
        :id,
        :testRunId,
        :passCount,
        :failCount,
        :pendingCount,
        :undefinedCount,
        :failedTests,
        :runTime,
        :status,
        :endDate,
        :startDate
    ]
    properties.each do |field|
      expect(model.respond_to? field).to be true
    end
  end

  it 'should raise on error for an undefined property' do
    model = DATSwagger::Models::TestRunResult.new
    expect(model.respond_to? :qweradsf).to be false
  end




end