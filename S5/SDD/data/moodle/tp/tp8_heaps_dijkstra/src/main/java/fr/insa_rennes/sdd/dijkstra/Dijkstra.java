package fr.insa_rennes.sdd.dijkstra;

import java.util.ArrayDeque;
import java.util.Deque;
import java.util.HashMap;
import java.util.Map;

import fr.insa_rennes.sdd.graph.Graph;
import fr.insa_rennes.sdd.graph.VertexAndWeight;
import fr.insa_rennes.sdd.priority_queue.PriorityQueue;

public class Dijkstra<T> {
	private final PriorityQueue<DijkstraNode<T>> pq;	
	private final Map<T, Double> cost = new HashMap<>();
	private final Map<T, T> prev = new HashMap<>();

	public Dijkstra(Graph<T> graph, T source) {
		this(graph, source, FactoryPQ.newInstance("HeapPQ"));
	}	

	public Dijkstra(Graph<T> graph, T source, PriorityQueue<DijkstraNode<T>> pq) {
		this.pq = pq; 
		solve(graph, source);
	}

	private void solve(Graph<T> graph, T source) {
		if (graph == null) { throw new IllegalArgumentException("Null graph"); }
		if (source == null) { throw new IllegalArgumentException("Null source"); }
		// Step 1 : insert source into PQ
		this.pq.add(new DijkstraNode<T>(0.0, source));
		// Step 2 : while the queue isn't empty
		while (!this.pq.isEmpty()) {
			// Step 3 : pop the first node out of the queue
			DijkstraNode<T> node = this.pq.poll();
			// Step 4 : look if the vertex has been treated yet or not
			// If it was, go back to 2
			if (this.cost.containsKey(node.vertex)) continue;
			// Step 5 : If it wasn't, insert it, and update prev later
			this.cost.put(node.vertex, node.cost);
			this.prev.put(node.vertex, node.prev);
			// Step 6 : For all the neighbors of node...
			for (VertexAndWeight<T> neighbor : graph.neighbors(node.vertex)) {
				// Add the neighbors with increasing distance
				this.pq.add(new DijkstraNode<T>(neighbor.weight+node.cost, neighbor.vertex, node.vertex));
			}
		}
	}

	public Deque<T> getPathTo(T v) {
		if (v == null) { throw new IllegalArgumentException("Null target"); }
		Deque<T> path = new ArrayDeque<T>();
		path.push(v);
		T road = v;
		while (this.cost.get(road) != 0) {
			road = this.prev.get(road);
			path.push(road);
		}
		return path;
	}

	public double getCost(T v) {
		return cost.getOrDefault(v, Double.POSITIVE_INFINITY);
	}
	
	public boolean hasPathTo(T v) {
		return getCost(v) != Double.POSITIVE_INFINITY;
	}

}
