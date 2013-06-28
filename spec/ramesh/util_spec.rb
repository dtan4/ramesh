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

  describe '#format_date_str' do
    context '201306281400' do
      it 'should return "2013-06-28 14:00"' do
        format_date_str('201306281400').should == '2013-06-28 14:00'
      end
    end

    context '20130628140' do
      it 'should return nil' do
        format_date_str('20130628140').should be_nil
      end
    end

    context '201313130000' do
      it 'should return nil' do
        format_date_str('201313130000').should be_nil
      end
    end

    context '201306282720' do
      it 'should return nil' do
        format_date_str('201306282720').should be_nil
      end
    end
  end
end
