% Di-graph of species interactions for Halophage data.
% 
% Version    Author       Date      Affiliation
% 1.00       J K Summers  19/12/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham

figure
nodes = {'S', 'N', 'P', 'V', 'B' 'I'};
% The Interactions matrix shows numbers of a species going into or coming 
% out of an event.
interactions = [0 1 0 0 0 0; 0 1 0 0 1 1; 0 0 1 0 1 0; 0 0 0 0 0 1; ...
    1 0 1 0 0 0; 1 0 0 1 0 0];
g = biograph(interactions, nodes);
% g.nodes(2).Shape = 'ellipse';
% g.nodes(4).Shape = 'ellipse';
% % Show weights allows the number of a species going into or coming out of
% % an event to be displayed
% g.ShowWeights = 'on';
view(g)
