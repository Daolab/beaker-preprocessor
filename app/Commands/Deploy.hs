{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE LambdaCase #-}
module Commands.Deploy where

import Process

import Control.Concurrent
import Control.Monad.IO.Class

import qualified Data.Attoparsec.ByteString as A
import qualified Data.ByteString.Char8 as B
import qualified Data.ByteString.Char8 as C8 (pack, unpack)
import qualified Data.ByteString.Base16 as B16 (decode)
import qualified Data.Text as T
import qualified Data.Text.IO as T
import qualified Data.Text.Encoding as T

import Network.Ethereum.Web3 hiding (runWeb3)
import Network.Ethereum.Web3.Web3
import Network.Ethereum.Web3.JsonAbi as JsonAbi
import Network.Ethereum.Web3.Types
import Network.Ethereum.Web3.Eth as Eth
import qualified Network.Ethereum.Web3.Address as Address

import Check.BeakerCompliance
import OpCode.Parser
import OpCode.Exporter
import OpCode.StructureParser
import OpCode.Type

import Text.Printf

import Utils

runDeploy :: IO ()
runDeploy = do
    kernelCode <- getKernelCode
    putStrLn "about to deploy"
    newContractAddress <- runWeb3 $ do
        accs <- accounts
        let sender = case accs of
                [] -> error "No accounts available"
                (a:_) -> a
        (res, txH, tx, txR) <- deployContract' sender kernelCode
        newContractAddressRaw <- getContractAddress' txH
        let newContractAddress = case newContractAddressRaw of
                Nothing -> error "contract not successfully deployed"
                Just x -> x
        pure newContractAddress
    print newContractAddress
    putStrLn "deployed"

compiledKernelPath = "Kernel.bin/Kernel.bin"
-- TODO: currently a bit of a hack
getKernelCode :: IO B.ByteString
getKernelCode = do
    B.readFile compiledKernelPath
