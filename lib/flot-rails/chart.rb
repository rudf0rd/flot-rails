module Flot
  class InvalidDataset < RuntimeError; end
    
  BaseOpts = {
    :bar => {bars: {show: true}, prefix: :bar},
    :line => {lines: {show: true}, prefix: :line},
    :point => {points: {show: true}, prefix: :point},
    :pie => {series: {pie: {show: true}}, prefix: :pie}
  };
  
  def on_click
  end
  
  def on_hover
  end
  
  def chart(dataset, opts={})
    @__chart_script_content ||= []
    
    split_flag = opts.delete(:split)
		el_width = opts.delete(:el_width)
		el_height = opts.delete(:el_height)
		target = opts.delete(:target)
		
    uniq_name = target ? target : [opts.delete(:prefix), :chart, dataset.join.hash.abs.to_s].compact.join('_')
    
    # dataset will be some kind of tripple nested arrays or an array of hashes with an 2-dimensional-array data-element
    raise InvalidDataset, dataset.inspect unless dataset.kind_of?(Array)
    dataset.each do |ele|
      raise InvalidDataset unless ele.kind_of?(Array) or (ele.kind_of?(Hash) and ele.has_key?(:data))
    end
    
		if target
			div = nil
		else
    	div = "<div class=\"inner\" id=\"#{uniq_name}\" style=\"width:600px;height:300px;\"></div>"
		end
		
    script = <<-HTML
		<script type='text/javascript'>
		  $(window).load(function () {
		    $.plot($("##{uniq_name}"), #{dataset.to_s.gsub(/:(\w*)=>/, '\1: ').gsub(/(\[|\{)(\[|\{)/, '\1' + "\n" + '\2  ').gsub(/],/, "],\n")}#{(', ' + opts.to_s.gsub(/:(\w*)=>/, '\1: ')) unless opts.empty? } ); 
		  });
		</script>
    HTML
    
    if split_flag
      @__chart_script_content << script
      return raw div
    elsif target and !div
			return raw script
		else
      return raw div + script
    end
  end
  
  def yield_chart_script_at(yield_tag)
    content_for yield_tag do raw @__chart_script_content.join end
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

__END__
// Interactive Mode for Points
function showTooltip(x, y, contents) {
    $('<div id="tooltip">' + contents + '</div>').css( {
        position: 'absolute',
        display: 'none',
        top: y + 5,
        left: x + 5,
        border: '1px solid #fdd',
        padding: '2px',
        'background-color': '#fee',
        opacity: 0.80
    }).appendTo("body").fadeIn(200);
}

var previousPoint = null;
$("#placeholder").bind("plothover", function (event, pos, item) {
    $("#x").text(pos.x.toFixed(2));
    $("#y").text(pos.y.toFixed(2));
    if (item) {
        if (previousPoint != item.dataIndex) {
            previousPoint = item.dataIndex;
            
            $("#tooltip").remove();
            var x = item.datapoint[0].toFixed(2),
                y = item.datapoint[1].toFixed(2);
            
            showTooltip(item.pageX, item.pageY,
                        item.series.label + " of " + x + " = " + y);
        }
    }
    else {
        $("#tooltip").remove();
        previousPoint = null;            
    }
});

$("#placeholder").bind("plotclick", function (event, pos, item) {
    if (item) {
        $("#clickdata").text("You clicked point " + item.dataIndex + " in " + item.series.label + ".");
        plot.highlight(item.series, item.datapoint);
    }
});
