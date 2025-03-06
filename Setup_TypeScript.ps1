# Display setup progress
Write-Host "Setting up your global TypeScript and local project environment..." -ForegroundColor Cyan

# Step 1: Create the main project folder
$projectFolder = "C:\Users\$env:USERNAME\Desktop\TypeScriptProject"
if (-Not (Test-Path $projectFolder)) {
    New-Item -ItemType Directory -Path $projectFolder -Force | Out-Null
}

# Step 2: Check if Node.js is installed
Write-Host "Checking for Node.js installation..." -ForegroundColor Yellow
if (-Not (Get-Command "node" -ErrorAction SilentlyContinue)) {
    Write-Host "Node.js is not installed. Downloading Node.js installer..." -ForegroundColor Red
    $nodeInstallerUrl = "https://nodejs.org/dist/latest/node-v20.5.1-x64.msi"
    $installerPath = "$env:TEMP\node-installer.msi"
    Invoke-WebRequest -Uri $nodeInstallerUrl -OutFile $installerPath
    Start-Process "msiexec.exe" -ArgumentList "/i $installerPath /quiet /norestart" -Wait
    Remove-Item $installerPath
    Write-Host "Node.js installed. Please restart your terminal if this is the first installation." -ForegroundColor Green
} else {
    Write-Host "Node.js is already installed." -ForegroundColor Green
}

# Step 3: Install TypeScript globally
Write-Host "Installing TypeScript globally..." -ForegroundColor Yellow
npm install -g typescript | Out-Null

# Verify TypeScript installation
Write-Host "Verifying TypeScript installation..." -ForegroundColor Yellow
if (-Not (Get-Command "tsc" -ErrorAction SilentlyContinue)) {
    Write-Host "TypeScript installation failed. Check your npm settings." -ForegroundColor Red
    Exit
} else {
    $tscVersion = tsc -v
    Write-Host "TypeScript installed successfully. Version: $tscVersion" -ForegroundColor Green
}

# Step 4: Add TypeScript Compiler (tsc) to the PATH environment variable
Write-Host "Adding TypeScript (tsc) to the PATH environment variable..." -ForegroundColor Yellow
$npmBinPath = npm bin -g
[System.Environment]::SetEnvironmentVariable("Path", "$($env:Path);$npmBinPath", [System.EnvironmentVariableTarget]::Machine)

# Check if the `tsc` command is available globally
if (Get-Command "tsc" -ErrorAction SilentlyContinue) {
    Write-Host "tsc added to PATH successfully!" -ForegroundColor Green
} else {
    Write-Host "Failed to add tsc to PATH. Please check your installation." -ForegroundColor Red
    Exit
}

# Step 5: Set up a local TypeScript project
Write-Host "Setting up a local TypeScript project..." -ForegroundColor Cyan

# Initialize npm project inside the project folder
Write-Host "Initializing npm project inside the project folder..." -ForegroundColor Yellow
Push-Location -Path $projectFolder
npm init -y | Out-Null
Pop-Location

# Step 6: Write to package.json
Write-Host "Updating package.json with provided configuration..." -ForegroundColor Yellow
$packageJson = @"
{
    "name": "typescript",
    "version": "1.0.0",
    "main": "index.js",
    "scripts": {
        "test": "echo 'Error: no test specified' && exit 1",
        "build": "tsc --project tsconfig.json",
        "start": "node ./dist/app.js",
        "build-start": "npm run build && node ./dist/app.js",
        "start-ts": "ts-node ./src/app.ts"
    },
    "author": "",
    "license": "ISC",
    "description": "",
    "devDependencies": {
        "ts-node": "^10.9.2",
        "typescript": "^5.7.3"
    }
}
"@
Set-Content -Path "$projectFolder\package.json" -Value $packageJson

# Step 7: Install dependencies
Write-Host "Installing local TypeScript and ts-node dependencies..." -ForegroundColor Yellow
Push-Location -Path $projectFolder
npm install | Out-Null
Pop-Location


# Step 8: Create tsconfig.json
Write-Host "Creating tsconfig.json file..." -ForegroundColor Yellow
$tsconfigJson = @"
{
    "compilerOptions": {
        "target": "es2016",
        "module": "commonjs",
        "rootDir": "./src",
        "sourceMap": true,
        "outDir": "./dist"
    }
}
"@
Set-Content -Path "$projectFolder\tsconfig.json" -Value $tsconfigJson

# Step 9: Create src directory and sample app.ts file
Write-Host "Creating src directory and sample app.ts file..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path "$projectFolder\src" -Force | Out-Null
$appTsContent = @"
// Basic TypeScript data types
let myName: string = "Mahmoud";
console.log(myName);

let counter: number = 10;
let appStatus: boolean = true;
let nullVar: null = null;
let undefinedVar: undefined = undefined;

let numberArray: number[] = [1, 2, 3];
let mixedArray: (number | string)[] = [1, "text", 4];

let tupleExample: [string, number] = ["TypeScript", 2025];
tupleExample = ["Updated", 42];

let anyVar: any = 10;
anyVar = "Changed Type";

// Type Alias
type Primitive = number | string | boolean | null;
let customArray: Primitive[] = [1, "hello", true, null];

// Enum Example
enum ApplicationStatus {
    Invited = "a1",
    InProgress = "a2",
    Submitted = "a3",
    Completed = "a4",
    Rejected = "a5",
}

const myStatus: ApplicationStatus = ApplicationStatus.Invited;
console.log(`Current Status: ${myStatus}`);

// Object with Typed Properties
interface User {
    name: string;
    status: ApplicationStatus;
    role: "admin" | "user";
}

let user: User = {
    name: "Mahmoud",
    status: ApplicationStatus.Completed,
    role: "admin",
};

// Function Overloading & Implementation
function addValues(a: number, b: number): number;
function addValues(a: string, b: string): string;
function addValues(a: number | string, b: number | string): number | string {
    if (typeof a === "number" && typeof b === "number") {
        return a + b;
    }
    return `${a} ${b}`;
}

console.log(addValues(10, 20)); // 30
console.log(addValues("Hello", "World")); // "Hello World"

// Generics Example
function identity<T>(value: T): T {
    return value;
}

console.log(identity<number>(42));
console.log(identity<string>("Generic Function"));

// Class Example
class Person {
    constructor(public name: string, private age: number) {}

    greet(): string {
        return `Hello, my name is ${this.name} and I am ${this.age} years old.`;
    }
}

const person1 = new Person("Mahmoud", 25);
console.log(person1.greet());

// Asynchronous Function Example
async function fetchData(): Promise<string> {
    return new Promise((resolve) =>
        setTimeout(() => resolve("Data fetched successfully!"), 2000)
    );
}

fetchData().then(console.log);

// Conclusion
console.log("TypeScript sample complete!");
"@
Set-Content -Path "$projectFolder\src\app.ts" -Value $appTsContent

# Step 10: Create a 'test' directory for testing purposes
Write-Host "Creating 'test' directory and sample test.ts file..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path "$projectFolder\test" -Force | Out-Null
$testTsContent = @"
const testMessage = (message: string): void => {
    console.log(\`Test Message: \${message}\`);
};
testMessage('Test Passed!');
"@
Set-Content -Path "$projectFolder\test\test.ts" -Value $testTsContent

# Step 11: Add cool text output for the test
Write-Host "
By Mahmoud Alfaiyumi from IIH Angular course.
" -ForegroundColor Green
$coolText = @"
 █████ █████ █████   █████ ███
░░███ ░░███ ░░███   ░░███ ░███
 ░███  ░███  ░███    ░███ ░███
 ░███  ░███  ░███████████ ░███
 ░███  ░███  ░███░░░░░███ ░███
 ░███  ░███  ░███    ░███ ░░░ 
 █████ █████ █████   █████ ███
░░░░░ ░░░░░ ░░░░░   ░░░░░ ░░░ 

* TypeScript Project Setup Complete! *
You can now use the following commands:
- Build: npm run build
- Run: npm run start
- Dev Mode: npm run start-ts

Happy Coding! 
"@
Write-Host $coolText

# Final message
Write-Host "Setup complete!" -ForegroundColor Green
