module Flot
  class InvalidDataset < RuntimeError; end
    
  BaseOpts = {
    :bar => {bars: {show: true}, prefix: :bar},
    :line => {lines: {show: true}, prefix: :line},
    :point => {points: {show: true}, prefix: :point},
    :pie => {series: {pie: {show: true}}, prefix: :pie}
  };
  
  def chart(dataset, opts={})
    readable_flag = opts.delete(:readable)
    uniq_name = [opts.delete(:prefix), :chart, dataset.join.hash.abs.to_s].compact.join('_')
    
    # dataset will be some kind of tripple nested arrays or an array of hashes with an 2-dimensional-array data-element
    raise InvalidDataset, dataset.inspect unless dataset.kind_of?(Array)
    dataset.each do |ele|
      raise InvalidDataset unless ele.kind_of?(Array) or (ele.kind_of?(Hash) and ele.has_key?(:data))
    end
    
    return raw (<<-HTML
<div class="inner" id="#{uniq_name}" style="width:600px;height:300px;"></div>
<script type='text/javascript'>
  $(window).load(function () {
    $.plot($(\"\##{uniq_name}\"), #{dataset.to_s.gsub(/:(\w*)=>/, "\n" + '\1: ').gsub(/(\[|\{)(\[|\{)/, '\1' + "\n" + '\2  ').gsub(/],/, "],\n")}#{(', ' + opts.to_s.gsub(/:(\w*)=>/, "\n" + '\1: ')) unless opts.empty? } ); 
  });
</script>
    HTML
    ).html_safe
  end
    
  def self.chart_type(name)
    define_method [name, 'chart'].join('_') do |ds, opts={}|
      chart(ds, BaseOpts[name].merge(opts))
    end
  end
  
  chart_type :bar
  chart_type :line
  chart_type :point
  chart_type :pie
end