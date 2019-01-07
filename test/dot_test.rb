require 'test_helper'

require 'rgl/dot'
require 'rgl/adjacency'

class TestDot < Test::Unit::TestCase

  def assert_match(dot, pattern)
    assert(!(dot =~ pattern).nil?, "#{dot} doesn't match #{pattern}")
  end

  def test_to_dot_digraph
    graph = RGL::DirectedAdjacencyGraph["a", "b"]

    begin
      dot   = graph.to_dot_graph.to_s

      first_vertex_id = "a"
      second_vertex_id = "b"

      assert_match(dot, /\{[^}]*\}/) # {...}
      assert_match(dot, /#{first_vertex_id}\s*\[/)  # node 1
      assert_match(dot, /label\s*=\s*a/)            # node 1 label
      assert_match(dot, /#{second_vertex_id}\s*\[/) # node 2
      assert_match(dot, /label\s*=\s*b/)            # node 2 label
      assert_match(dot, /#{first_vertex_id}\s*->\s*#{second_vertex_id}/) # edge
    rescue
      puts "Graphviz not installed?"
    end
  end

  def test_to_dot_digraph_with_options
      graph = RGL::DirectedAdjacencyGraph["a", "b"]

    begin
      edge_labels = {}
      graph.each_edge do |b, e|
        key              = "#{b}-#{e}"
        edge_labels[key] = "#{b} to #{e}"
      end
      label_setting = Proc.new{|b, e| edge_labels["#{b}-#{e}"]}
      dot_options   = {'edge' => {'color' => 'red', 'label' => label_setting}}
      dot           = graph.to_dot_graph(dot_options).to_s

      assert_match(dot, /color\s*=\s*red/)
      assert_match(dot, /a to b/)
    rescue
      puts "Graphviz not installed?"
    end
  end

  def test_to_dot_graph
    graph = RGL::AdjacencyGraph["a", "b"]
    def graph.vertex_label(v)
      "label-"+v.to_s
    end

    def graph.vertex_id(v)
      "id-"+v.to_s
    end
    begin
      graph.write_to_graphic_file
    rescue
      puts "Graphviz not installed?"
    end
  end
end
