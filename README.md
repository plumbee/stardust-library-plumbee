stardust-library-plumbee
========================

Fork of the open source Stardust library version 1.3.186. Contains bugfixes and new features for the 2D part of the library.

First commit is exactly the same as Stardust 1.3.186 except that we removed classes that acted as handlers for 3D libraries. The following packages are removed:  
threeD/alternativa3d  
threeD/away3d  
threeD/away3dlite  
threeD/flare3d  
threeD/nd3d  
threeD/papervision3d   
These are removed because the following reasons:  
- They include deependencies with various licenses. 
- Most of these libraries are not in development anymore or the handlers are written for very old versions.  





