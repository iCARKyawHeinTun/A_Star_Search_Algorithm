% A* Search Algorithm
% "nodes.csv" and "edges.csv" files have to be in the 
% same folder where the code is
clear ; 
clc ; 
nodes = readmatrix('nodes.csv','CommentStyle','#') ;
edges = readmatrix('edges.csv','CommentStyle','#') ;
optimistic_ctg  = nodes(:,4) ;
past_cost       = [0;Inf(height(nodes)-1,1)] ;  % past_cost for node one is zero, others are infinity
est_tot_cost    = optimistic_ctg + past_cost ;  % estimate_total_cost = optimistic_cost_to_go + past_cost 
parent_node     = zeros(height(nodes),1) ;      % initializing parent nodes
OPEN_NODES      = zeros(height(nodes),2)  ;   
OPEN_NODES(1,:) = [1,est_tot_cost(1)]  ;                    % assign node 1 to explore from
CLOSED_NODES    = zeros(height(nodes),2) ;    
flag            = 0 ;
flag_to_update_OPEN = 1 ; 
closed_nodes_rows = 1 ; 
i = 1 ; 
a = 1 ;
goal = 12 ; 
start = OPEN_NODES(1,1) ; 
prv_OPEN_NODE = 0 ; 
prv_est_tot_cost =  [Inf(height(nodes),1)] ; 
prv_past_cost =  [0;Inf(height(nodes)-1,1)] ;  
path = [] ; 
   
% the following while loop is the algorithm from the text book
while flag == 0      
        for rows = 1:1:height(edges)
            % the following "two if loops" search the columns of the edges 
            if edges(rows,1) == OPEN_NODES(1,1)
                aaa = replaceWith0IfEmpty(find(CLOSED_NODES(:,1)==edges(rows,2))) ;
                if  aaa == 0
                    past_cost(edges(rows,2)) = past_cost(OPEN_NODES(1,1)) + edges(rows,3) ; 
                    if past_cost(edges(rows,2)) < prv_past_cost(edges(rows,2)) % update past cost if lesser
                        past_cost(edges(rows,2)) = past_cost(edges(rows,2)) ;
                    else
                        past_cost(edges(rows,2)) = prv_past_cost(edges(rows,2)) ; % use the previous one if the cost is larger
                    end
                    est_tot_cost    =   optimistic_ctg + past_cost ; % calculate the estimated total cost 
                    % if the current total cost if less than the previous one
                    if est_tot_cost(edges(rows,2)) < prv_est_tot_cost(edges(rows,2))
                        parent_node(edges(rows,2)) = OPEN_NODES(1,1) ; % update the parent node
                        flag_to_update_OPEN = flag_to_update_OPEN + 1 ;
                        OPEN_NODES(flag_to_update_OPEN,1) = edges(rows,2) ; % update the OPEN array
                        OPEN_NODES(flag_to_update_OPEN,2) = est_tot_cost(OPEN_NODES(flag_to_update_OPEN,1)) ;
                    end
                end
            end
            if edges(rows,2) == OPEN_NODES(1,1)
                bbb = replaceWith0IfEmpty(find(CLOSED_NODES(:,1)==edges(rows,1))) ;
                if  bbb == 0
                    past_cost(edges(rows,1)) = past_cost(OPEN_NODES(1,1)) + edges(rows,3) ;
                    if past_cost(edges(rows,1)) < prv_past_cost(edges(rows,1))
                        past_cost(edges(rows,1)) = past_cost(edges(rows,1)) ;
                    else
                        past_cost(edges(rows,1)) = prv_past_cost(edges(rows,1)) ; 
                    end
                    est_tot_cost    =   optimistic_ctg + past_cost ;
                    if est_tot_cost(edges(rows,1)) < prv_est_tot_cost(edges(rows,1))
                        parent_node(edges(rows,1)) = OPEN_NODES(1,1) ;
                        flag_to_update_OPEN = flag_to_update_OPEN + 1 ; 
                        OPEN_NODES(flag_to_update_OPEN,1) = edges(rows,1) ;
                        OPEN_NODES(flag_to_update_OPEN,2) = est_tot_cost(OPEN_NODES(flag_to_update_OPEN,1)) ;
                    end
                end
            end
        end
        
        % already explored nodes
        CLOSED_NODES(closed_nodes_rows,:)  = OPEN_NODES(1,:) ;
        prv_past_cost = past_cost ;
        prv_est_tot_cost = est_tot_cost ; 
        if OPEN_NODES(1,1) == goal ;
        flag = 1 ; 
        end
        closed_nodes_rows = closed_nodes_rows + 1 ; 
        prv_OPEN_NODE = OPEN_NODES(1,1) ;
        OPEN_NODES(1,:) = [0,0] ; 
        % arrange the nodes in ascending order of toal cost
        OPEN_NODES      =   sortrows(OPEN_NODES,2) ; 
        for j = 1:1:height(OPEN_NODES)
            if OPEN_NODES(j,1) ~= 0
                OPEN_NODES(i,:) = OPEN_NODES(j,:) ; 
                OPEN_NODES(j,:) = [0,0] ; 
                i = i + 1 ;
            end
        end
        i = 1 ; 
end

% find the path 
goal_check = goal ; 

while parent_node(goal_check) ~= 1
    path = [ path , parent_node(goal_check) ] ; 
    goal_check = parent_node(goal_check) ; 
end

path = [start , flip(path) , goal ] ; 
csvwrite('path.csv',path) ; 


function x = replaceWith0IfEmpty(x)
if isempty(x)
    x = 0;
end
end