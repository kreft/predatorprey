# predatorprey
ODE model of Bdellovibrio bacteriovorus and halo-phage predation of Escherichia coli including Approximate Bayesian Computation model selection and parameter inference

This file contains some explanations of the code.

See this manuscript and supplemental material for details on the model, the data, and how they come together:

Laura Hobley, J Kimberley Summers, Rob Till, David S. Milner, Robert J Atterbury, Amy Stroud, Michael J. Capeness, Stephanie Gray, Andreas Leidenroth, Carey Lambert, Ian Connerton, Jamie Twycross, Michelle Baker, Jess Tyson, Jan-Ulrich Kreft, R. Elizabeth Sockett (2019). Dual predation by bacteriophage and Bdellovibrio can eradicate E. coli prey in situations where single predation cannot.

The code was written by J Kimberley Summers (JKS282@student.bham.ac.uk), Kreft Lab, School of Biosciences, University of Birmingham, UK

It is written in Matlab (m files). It reads in input files called protocols (Excel files).

The best point to start with the code is "NottinghamPhageSMC.m" which runs the whole Sequential Monte Carlo process of model selection and fitting.

Each model variant (mode) has its own input file, see the "Mode descriptor.txt" file for a mapping of model variants in the paper and mode numbers.

Here the mapping of the variables in the model code to variables in the paper:

Paper									                Code
Medium									              sub for substrate
Sensitive prey							          senPrey
Bdellovibrio plastic persistent prey	bdPersistPrey
Phage resistant prey					        phageResPrey
Bdellovibrio							            bd
Bdelloplast								            bdplast
Halo-phage								            phage
Infected cell							            infCell
Signal									              deadPrey

Other explanations:
compMode should be set to 4, this is the distance function chosen and described in the paper.

Copyright holder of this software: J Kimberley Summers

The open-source code is made available under a GNU GPL version 3 licence, please see http://www.gnu.org/licenses/gpl-3.0.html for details.

You can use, modify and/or redistribute the software under the terms of the GNU GPL licence.

As a counterpart to the access to the source code and rights to copy,
modify and redistribute granted by this license, users are provided only
with a limited warranty and the software's author, the holder of the
economic rights, and the successive licensors have only limited
liability. 

In this respect, the user's attention is drawn to the risks associated
with loading, using, modifying and/or developing or reproducing the
software by the user in light of its specific status of free software,
that may mean that it is complicated to manipulate, and that also
therefore means that it is reserved for developers and experienced
professionals having in-depth computer knowledge. Users are therefore
encouraged to load and test the software's suitability as regards their
requirements in conditions enabling the security of their systems and/or 
data to be ensured and, more generally, to use and operate it in the 
same conditions as regards security. 

The fact that you are presently reading this means that you have had
knowledge of the GNU GPL license and that you accept its terms.

Moreover authors ask to be acknowledged in any scientific publications based on 
or using some part of this software by citing the above paper by Hobley et al.
