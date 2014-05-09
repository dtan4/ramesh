require 'spec_helper'

module Ramesh
  describe Client do
    let(:client) { client = Ramesh::Client.new }

    describe "#download_sequential_image" do
      context "0-20" do
        it "should download 5 images" do
          client.download_sequential_image('0-20')
          expect(Dir.glob("*.gif").length).to eq(5)
        end
      end

      context "20-0" do
        it "should download 5 images" do
          client.download_sequential_image('20-0')
          expect(Dir.glob("*.gif").length).to eq(5)
        end
      end

      context "30-80" do
        it "should download 11 images" do
          client.download_sequential_image('30-80')
          expect(Dir.glob("*.gif").length).to eq(11)
        end
      end

      context "0-120" do
        it "should download 25 images" do
          client.download_sequential_image('0-120')
          expect(Dir.glob("*.gif").length).to eq(25)
        end
      end

      context "0-130" do
        it "should not download any image" do
          expect { client.download_sequential_image('0-130') }.to raise_error SystemExit
        end
      end
    end

    after(:each) do
      Dir.glob("*.gif").each { |gif| File.delete(gif) }
    end
  end
end
