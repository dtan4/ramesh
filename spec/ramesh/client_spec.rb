require 'spec_helper'

module Ramesh
  describe Client do
    let(:client) { Ramesh::Client.new }

    describe "#download_sequential_image" do
      context "0-20" do
        pending "should download 5 images" do
          client.download_sequential_image('0-20')
          expect(Dir.glob("*.gif")).to have(5).items
        end
      end

      context "20-0" do
        pending "should download 5 images" do
          client.download_sequential_image('20-0')
          expect(Dir.glob("*.gif")).to have(5).items
        end
      end

      context "30-80" do
        pending "should download 11 images" do
          client.download_sequential_image('30-80')
          expect(Dir.glob("*.gif")).to have(11).items
        end
      end

      context "0-120" do
        pending "should download 25 images" do
          client.download_sequential_image('0-120')
          expect(Dir.glob("*.gif")).to have(25).items
        end
      end

      context "0-130" do
        pending "should not download any image" do
          expect { client.download_sequential_image('0-130') }.to raise_error SystemExit
        end
      end
    end

    after(:each) do
      Dir.glob("*.gif").each { |gif| File.delete(gif) }
    end
  end
end
