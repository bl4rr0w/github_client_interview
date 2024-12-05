require 'spec_helper'
require 'httparty'
require_relative '../../client'

RSpec.describe Github::Client do
  let(:repo_url) { 'https://api.github.com/repos/paper-trail-gem/paper_trail' }
  let(:client) { described_class.new(ENV['TOKEN'], repo_url) }

  describe '#get' do
    context 'when the request is successful' do
      it 'returns a response object with status 200' do
        allow(HTTParty).to receive(:get).and_return(double('response', code: 200, body: '[]'))

        response = client.get('/issues')

        expect(response.code).to eq(200)
        expect(response.body).to eq('[]')
      end
    end

    context 'when the request is unauthorized (401)' do
      it 'raises an error for unauthorized access' do
        allow(HTTParty).to receive(:get).and_return(double('response', code: 401, body: '{"message": "Bad credentials"}'))

        expect { client.get('/issues') }.to raise_error(RuntimeError, 'Error: Unable to fetch data (HTTP 401)')
      end
    end
  end
end