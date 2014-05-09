require 'spec_helper'
require 'time'

WebMock.allow_net_connect!

module Ramesh
  describe Util do
    include Ramesh::Util

    describe "#extract_filename" do
      context "http://tokyo-ame.jwa.or.jp/map/map000.jpg" do
        it "should return map000.jpg" do
          expect(extract_filename("http://tokyo-ame.jwa.or.jp/map/map000.jpg")).to eq "map000.jpg"
        end
      end

      context "http://tokyo-ame.jwa.or.jp/map/" do
        it "should return empty String" do
          expect(extract_filename("http://tokyo-ame.jwa.or.jp/map/")).to eq ""
        end
      end
    end

    describe "#get_mesh_indexes" do
      before do
        stub_request(:get, "http://tokyo-ame.jwa.or.jp/scripts/mesh_index.js")
          .to_return(body: open(fixture_path("mesh_index.js")).read, status: 200)
      end

      let(:indexes) { get_mesh_indexes }

      context "downloaded indexes" do
        it "should be Array" do
          expect(indexes).to be_a Array
        end

        it "should be sorted by desc" do
          expect(indexes).to eq indexes.sort.reverse
        end

        it "should have 25 items" do
          expect(indexes).to have(25).items
        end

        it "item should be 12 digit number" do
          indexes.each do |index|
            expect(index).to match /^\d{12}$/
          end
        end
      end
    end

    describe "#validate_minutes" do
      context "0" do
        it "should be true" do
          expect(validate_minutes(0)).to be_true
        end
      end

      context "5" do
        it "should be true" do
          expect(validate_minutes(5)).to be_true
        end
      end

      context "7" do
        it "should be false" do
          expect(validate_minutes(7)).to be_false
        end
      end

      context "120" do
        it "should be true" do
          expect(validate_minutes(120)).to be_true
        end
      end

      context "130" do
        it "should be false" do
          expect(validate_minutes(130)).to be_false
        end
      end

      context "-5" do
        it "should be false" do
          expect(validate_minutes(130)).to be_false
        end
      end
    end
  end
end
