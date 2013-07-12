require 'spec_helper'
require 'time'

module Ramesh
  describe Util do
    include Ramesh::Util

    describe '#extract_filename' do
      context 'http://tokyo-ame.jwa.or.jp/map/map000.jpg' do
        it 'should return "map000.jpg"' do
          extract_filename('http://tokyo-ame.jwa.or.jp/map/map000.jpg').should == 'map000.jpg'
        end
      end

      context 'http://tokyo-ame.jwa.or.jp/map/' do
        it 'should return ""' do
          extract_filename('http://tokyo-ame.jwa.or.jp/map/').should == ''
        end
      end
    end

    describe '#get_mesh_indexes' do
      before(:all) do
        @indexes = get_mesh_indexes
      end

      context 'downloaded indexes' do
        it 'should be Array' do
          @indexes.class.should == Array
        end

        it 'should be sorted decrementally' do
          @indexes.should == @indexes.sort.reverse
        end

        it 'should have 25 items' do
          @indexes.length.should == 25
        end

        25.times do |i|
          it "indexes[#{i}] should be 12 digit number" do
            @indexes[i].should =~ /^\d{12}$/
          end
        end
      end
    end

    describe "#validate_minutes" do
      context "0" do
        it 'should be true' do
          validate_minutes(0).should be_true
        end
      end

      context "5" do
        it 'should be true' do
          validate_minutes(5).should be_true
        end
      end

      context "7" do
        it 'should be false' do
          validate_minutes(7).should be_false
        end
      end

      context "120" do
        it 'should be true' do
          validate_minutes(120).should be_true
        end
      end

      context "130" do
        it 'should be false' do
          validate_minutes(130).should be_false
        end
      end

      context "-5" do
        it 'should be false' do
          validate_minutes(130).should be_false
        end
      end
    end
  end
end
