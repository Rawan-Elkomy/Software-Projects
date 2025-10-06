import util

class SearchProblem:

    def getStartState(self):
        util.raiseNotDefined()

    def isGoalState(self, state):
        util.raiseNotDefined()

    def getSuccessors(self, state):
        util.raiseNotDefined()

    def getCostOfActions(self, actions):
        util.raiseNotDefined()

def tinyMazeSearch(problem):
    from game import Directions
    s = Directions.SOUTH
    w = Directions.WEST
    return  [s, s, w, s, w, w, s, w]

def depthFirstSearch(problem: SearchProblem):
    """Search the deepest nodes in the search tree first."""
    stack = util.Stack()
    stack.push((problem.getStartState(), []))  # (current state, actions to reach it)
    visited = set()

    while not stack.isEmpty():
        state, actions = stack.pop()

        if state in visited:
            continue

        visited.add(state)

        if problem.isGoalState(state):
            return actions

        for successor, action, cost in problem.getSuccessors(state):
            if successor not in visited:
                stack.push((successor, actions + [action]))

    return []

def breadthFirstSearch(problem: SearchProblem):
    """Search the shallowest nodes in the search tree first."""
    queue = util.Queue()
    queue.push((problem.getStartState(), []))  # (current state, actions to reach it)
    visited = set()

    while not queue.isEmpty():
        state, actions = queue.pop()

        if state in visited:
            continue

        visited.add(state)

        if problem.isGoalState(state):
            return actions

        for successor, action, cost in problem.getSuccessors(state):
            if successor not in visited:
                queue.push((successor, actions + [action]))

    return []

def uniformCostSearch(problem: SearchProblem):
    """Search the node of least total cost first."""
    priority_queue = util.PriorityQueue()
    priority_queue.push((problem.getStartState(), [], 0), 0)  # (state, actions, cost)
    visited = {}

    while not priority_queue.isEmpty():
        state, actions, current_cost = priority_queue.pop()

        if state in visited and visited[state] <= current_cost:
            continue

        visited[state] = current_cost

        if problem.isGoalState(state):
            return actions

        for successor, action, cost in problem.getSuccessors(state):
            new_cost = current_cost + cost
            if successor not in visited or visited[successor] > new_cost:
                priority_queue.push((successor, actions + [action], new_cost), new_cost)

    return []

def nullHeuristic(state, problem=None):
    """
    A heuristic function estimates the cost from the current state to the nearest
    goal in the provided SearchProblem.  This heuristic is trivial.
    """
    return 0

def manhattanHeuristic(position, problem, info={}):
    """The Manhattan distance heuristic for a PositionSearchProblem"""
    xy1 = position
    xy2 = problem.goal
    return abs(xy1[0] - xy2[0]) + abs(xy1[1] - xy2[1])

def aStarSearch(problem: SearchProblem, heuristic=nullHeuristic):
    """Search the node that has the lowest combined cost and heuristic first."""
    priority_queue = util.PriorityQueue()
    start_state = problem.getStartState()
    priority_queue.push((start_state, [], 0), heuristic(start_state, problem))  # (state, actions, cost)
    visited = {}

    while not priority_queue.isEmpty():
        state, actions, current_cost = priority_queue.pop()

        if state in visited and visited[state] <= current_cost:
            continue

        visited[state] = current_cost

        if problem.isGoalState(state):
            return actions

        for successor, action, cost in problem.getSuccessors(state):
            new_cost = current_cost + cost
            priority = new_cost + heuristic(successor, problem)
            if successor not in visited or visited[successor] > new_cost:
                priority_queue.push((successor, actions + [action], new_cost), priority)

    return []
