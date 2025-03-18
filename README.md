# nvim

Add this to the $HOME/.config directory


Open nvim ,  You will see a new window which will be installing all the plugins you need.
 After installing all the plugins, Restart nvim and run the following commands
```
:Lazy sync
:Lazy clean
:Lazy check
```

### For running java11, Additionally you have to do the following

- Make sure the JAVA_HOME is set properly in your environmental variables 

- Download the jdtls from https://download.eclipse.org/jdtls/milestones/       -0.57 version
    - Extract the Downloaded one and Rename it as jdtls
    - Create a directory if not  $HOME/.local/nvim/
    - Place the renamed folder into the above directory ( $HOME/.local/nvim )
- Run the following command
```
:MasonInstall java-debug-adapter
```
- Download test debug adapter from https://mvnrepository.com/artifact/com.microsoft.java/com.microsoft.java.debug.plugin        -0.46.0 version
    - Create the directory if not 
    - Replace the downloaded jar into the $HOME/.local/share/nvim/mason/packages/java-debug-adapter/extension/server directory
