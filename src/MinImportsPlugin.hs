-- |
-- Copyright: (c) 2020 jrp2014
-- SPDX-License-Identifier: MIT
-- Maintainer: jrp2014 <jrp2014@users.noreply.github.com>
--
-- See README for more info
module MinImportsPlugin
  ( plugin
  )
where

import           Avail
import           Control.Monad.IO.Class
import           DynFlags                       ( getDynFlags )
import           HsDecls
import           HsDoc
import           HsExpr
import           HsExtension
import           HsImpExp
import           HscTypes
import           Outputable
import           Plugins
import           TcRnTypes
import           RnNames
import           IOEnv                          ( readMutVar )
import           Control.Monad (guard)
import           SrcLoc

plugin :: Plugin
plugin = defaultPlugin { parsedResultAction    = parsedPlugin
                       , renamedResultAction   = renamedAction
                       , typeCheckResultAction = typecheckPlugin
                       , spliceRunAction       = metaPlugin
                       , interfaceLoadAction   = interfaceLoadPlugin
                       }

parsedPlugin
  :: [CommandLineOption] -> ModSummary -> HsParsedModule -> Hsc HsParsedModule
parsedPlugin _ _ pm = do
  dflags <- getDynFlags
  liftIO $ putStrLn $ "parsePlugin: \n" ++ showSDoc dflags (ppr $ hpm_module pm)
  return pm

renamedAction
  :: [CommandLineOption]
  -> TcGblEnv
  -> HsGroup GhcRn
  -> TcM (TcGblEnv, HsGroup GhcRn)
renamedAction _ tc gr = do
  dflags <- getDynFlags
  liftIO $ putStrLn $ "typeCheckPlugin (rn): " ++ showSDoc dflags (ppr gr)
  return (tc, gr)

typecheckPlugin :: [CommandLineOption] -> ModSummary -> TcGblEnv -> TcM TcGblEnv
typecheckPlugin _ _ tc = do
  dflags <- getDynFlags
  liftIO $ putStrLn $ "typeCheckPlugin (rn): \n" ++ showSDoc
    dflags
    (ppr $ tcg_rn_decls tc)
  liftIO $ putStrLn $ "typeCheckPlugin (tc): \n" ++ showSDoc
    dflags
    (ppr $ tcg_binds tc)

  liftIO $ putStrLn $ "typeCheckPlugin (tc): imports\n" ++ showSDoc
    dflags
    (ppr $ tcg_rn_imports tc)

  -- findImportUsage :: [LImportDecl GhcRn] -> [GlobalRdrElt] -> [ImportDeclUsage]
  -- getMinimalImports ::  [ImportDeclUsage] -> RnM [LImportDecl GhcRn]
  -- tcg_used_gres :: TcGblEnvSource -> TcRef [GlobalRdrElt]
  -- tcg_rn_imports :: TcGblEnvSource ->[LImportDecl GhcRn]
  let user_imports = filter (not . ideclImplicit . unLoc) (tcg_rn_imports tc)
  uses  <- readMutVar $ tcg_used_gres tc
  usage <- getMinimalImports $ findImportUsage user_imports uses
  liftIO $ putStrLn $ "typeCheckPlugin (tc): minimal imports\n" ++ showSDoc dflags (ppr usage)

  return $ tc { tcg_rn_imports = usage }

metaPlugin :: [CommandLineOption] -> LHsExpr GhcTc -> TcM (LHsExpr GhcTc)
metaPlugin _ meta = do
  dflags <- getDynFlags
  liftIO $ putStrLn $ "meta: " ++ showSDoc dflags (ppr meta)
  return meta

interfaceLoadPlugin :: [CommandLineOption] -> ModIface -> IfM lcl ModIface
interfaceLoadPlugin _ iface = do
  dflags <- getDynFlags
  liftIO $ putStrLn $ "interface loaded: " ++ showSDoc dflags
                                                       (ppr $ mi_module iface)
  return iface
