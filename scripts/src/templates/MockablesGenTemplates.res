let mockableFunctionBody = (~functionName, ~storageParameters, ~mockerParameterCalls) =>
  `
if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("${functionName}"))){
  ${storageParameters}
  return mocker.${functionName}Mock(${mockerParameterCalls});
}
`
let externalMockerFunctionBody = (
  ~functionName,
  ~mockerArguments,
  ~mockerReturnValues,
  ~mockerReturn,
) =>
  `
  function ${functionName}Mock(${mockerArguments}) public pure ${mockerReturnValues}{
    return (${mockerReturn});
  }
`

let mockableModifierBody = (
  ~functionName,
  ~storageParameters,
  ~mockerParameterCalls,
  ~functionBody,
) =>
  `
if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("${functionName}"))){
  ${storageParameters}
  mocker.${functionName}Mock(${mockerParameterCalls});
  _;
} else {
  ${functionBody}
}
`

let externalMockerModifierBody = (~functionName, ~mockerArguments) =>
  `
function ${functionName}Mock(${mockerArguments}) public pure {}
`

let internalMockingFileTemplate = (~fileNameWithoutExtension, ~parentImports, ~contractBody) =>
  `// SPDX-License-Identifier: BUSL-1.1 \n pragma solidity 0.8.3;

import "./${fileNameWithoutExtension}Mockable.sol"

${parentImports}

contract ${fileNameWithoutExtension}ForInternalMocking {
  ${contractBody}
}`

let mockingFileTemplate = (~prefix, ~fileNameWithoutExtension, ~modifiersAndOpener, ~suffix) => {
  `${prefix}
import "./${fileNameWithoutExtension}ForInternalMocking.sol";

contract ${fileNameWithoutExtension}Mockable${modifiersAndOpener}

  ${fileNameWithoutExtension}ForInternalMocking mocker;
  bool shouldUseMock;
  string functionToNotMock;

  function setMocker(${fileNameWithoutExtension}ForInternalMocking _mocker) external {
    mocker = _mocker;
    shouldUseMock = true;
  }

  function setFunctionToNotMock(string calldata _functionToNotMock) external {
    functionToNotMock = _functionToNotMock;
  }

${suffix}
`
}
