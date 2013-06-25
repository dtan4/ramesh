require 'spec_helper'

describe Util do
  include Util

  describe '#extract_filename' do
    context 'http://tokyo-ame.jwa.or.jp/map/map000.jpg' do
      it 'returns "map000.jpg"' do
        extract_filename('http://tokyo-ame.jwa.or.jp/map/map000.jpg').should == 'map000.jpg'
      end
    end

    context 'http://tokyo-ame.jwa.or.jp/map/' do
      it 'returns ""' do
        extract_filename('http://tokyo-ame.jwa.or.jp/map/').should == ''
      end
    end
  end

  describe '#get_mesh_indexes' do
    before(:all) do
      @indexes = get_mesh_indexes
    end

    context 'downloaded indexes' do
      it 'is Array' do
        @indexes.class.should == Array
      end

      it 'has 25 items' do
        @indexes.length.should == 25
      end

      it 'has 5 minutes interval between items'

      it 'is sorted decrementally' do
        @indexes.should == @indexes.sort.reverse
      end
    end
  end
end
