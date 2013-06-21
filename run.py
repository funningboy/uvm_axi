import sys
import time
import unittest
import os
import re
import subprocess

DEBUG = True

re_UVM_ERROR    = re.compile("^UVM_ERROR\s+:\s+(\d+)$"    ,re.M)
re_UVM_WARNING  = re.compile("^UVM_WARNING\s+:\s+(\d+)$"  ,re.M)
re_UVM_INFO     = re.compile("^UVM_INFO\s+:\s+(\d+)$"     ,re.M)
re_IUS_ERROR    = re.compile("^irun:\s+\*E\,"             ,re.M)
re_IUS_WARNING  = re.compile("^irun:\s+\*W\,"             ,re.M)

class IUSAXIBase(unittest.TestCase):

    def setUp(self):
        os.chdir('/user/seanchen/project/uvm_axi')
        self.m_demo_home    = os.getcwd()
        self.m_tb_home      = None
        self.m_tb_name      = None

    def tearDown(self):
        global DEBUG
        if not DEBUG:
            self.clearIUS();

    def runIUS(self):
        """ run IUS ps: it need subprocess to parallel run """

        m_str = "irun -uvm \
          -incdir %(DEMO_HOME)s/sv \
          -incdir %(DEMO_HOME)s/sv/sequence_libs \
          -incdir %(DEMO_HOME)s/v \
          -incdir %(DEMO_HOME)s/pli \
          -incdir %(DEMO_HOME)s/dpi \
          -incdir %(TB_HOME)s \
          +notimingchecks \
          +notchkmsg \
          +no_notifier \
          +define+AXI_BUSY \
          +libext+.v \
          %(DEMO_HOME)s/pli/dram.c  \
          %(DEMO_HOME)s/pli/vpi_user.c \
          -loadvpi mem_alloc,mem_free,mem_read,mem_write,mem_init,mem_dump.register_user_tasks \
          -coverage b:u \
          -covoverwrite \
          +UVM_TESTNAME=%(TEST_NAME)s \
          +UVM_VERBOSITY=UVM_FULL \
          %(TB_HOME)s/demo_top.sv \
          +access+rwc" % { 'DEMO_HOME' : self.m_demo_home, \
                           'TEST_NAME' : self.m_tb_name, \
                           'TB_HOME'   : self.m_tb_home}

        subprocess.call(m_str, shell=True)

    def reportIUS(self):
        """ report IUS """
        # it need subprocess to return the sysout result
        # >>> grep "*E" irun.log
        # >>> grep "UVM_ERROR" irun.log ...

        f = open('./log/%(TEST_NAME)s.log' % { 'TEST_NAME' : self.m_tb_name})
        uvm_errs = re_UVM_ERROR.findall(f.read())
        ius_errs = re_IUS_ERROR.findall(f.read())
        uvm_warns = re_UVM_WARNING.findall(f.read())
        ius_warns = re_IUS_WARNING.findall(f.read())

        if len(ius_errs) == 0:
            if uvm_errs[0] == '0':
                return True
        return False

    def clearIUS(self):
        """ clear """
        os.system("rm -rf cov_work")
        os.system("rm -rf INCA_libs")
        os.system("rm -rf *.vcd*")


    def logIUS(self):
        """ move to log """
        m_str = 'mv irun.log ./log/%(TEST_NAME)s.log' % { 'TEST_NAME' : self.m_tb_name}
        m_vcd = 'mv demo_tb.vcd ./log/%(TEST_NAME)s.vcd' % { 'TEST_NAME' : self.m_tb_name}
        os.system(m_str)
        os.system(m_vcd)


class TestAXIBFMVirtual(IUSAXIBase):
    """ test virtual AXI bus functional model """

    def test_phase_write_data_after_write_addr(self):
        """ test AXI write data phase is after write addr phase """

        self.m_tb_home = self.m_demo_home + '/examples/virtual_master_to_virtual_slave'
        self.m_tb_name = 'Test_write_data_after_write_addr'

        self.runIUS()
        self.logIUS()
        self.assertEqual(self.reportIUS(), True)

    def test_phase_write_addr_after_write_data(self):
        """ test AXI write addr phase is after write data phase """

        self.m_tb_home = self.m_demo_home + '/examples/virtual_master_to_virtual_slave'
        self.m_tb_name = 'Test_write_addr_after_write_data'

        self.runIUS()
        self.logIUS()
        self.assertEqual(self.reportIUS(), True)


    def test_phase_wite_addr_write_data_at_same_time(self):
        """ test AXI write addr and write data at the same time """

        self.m_tb_home = self.m_demo_home + '/examples/virtual_master_to_virtual_slave'
        self.m_tb_name = 'Test_write_addr_write_data_at_same_time'

        self.runIUS()
        self.logIUS()
        self.assertEqual(self.reportIUS(), True)


    def test_phase_write_interleave_data(self):
        """ test AXI write interleave data """

        self.m_tb_home = self.m_demo_home + '/examples/virtual_master_to_virtual_slave'
        self.m_tb_name = 'Test_write_interleave_data'

        self.runIUS()
        self.logIUS()
        self.assertEqual(self.reportIUS(), True)


    def test_phase_write_out_of_performance(self):
        """ test AXI write out of performance """

        self.m_tb_home = self.m_demo_home + '/examples/virtual_master_to_virtual_slave'
        self.m_tb_name = 'Test_write_out_of_performance'

        self.runIUS()
        self.logIUS()
        self.assertEqual(self.reportIUS(), False)


    def test_phase_read_out_of_performance(self):
        """ test AXI read out of performance """

        self.m_tb_home = self.m_demo_home + '/examples/virtual_master_to_virtual_slave'
        self.m_tb_name = 'Test_read_out_of_performance'

        self.runIUS()
        self.logIUS()
        self.assertEqual(self.reportIUS(), False)


class TestAXIBFMDUT(IUSAXIBase):
    """ test AXI bus functional model """

    def test_phase_write_data_after_write_addr(self):
        """ test AXI write data phase is after write addr phase """

        self.m_tb_home = self.m_demo_home + '/examples/virtual_master_to_dut_slave'
        self.m_tb_name = 'Test_write_data_after_write_addr'

        self.runIUS()
        self.logIUS()
        self.assertEqual(self.reportIUS(), True)

    def test_phase_write_addr_after_write_data(self):
        """ test AXI write addr phase is after write data phase """

        self.m_tb_home = self.m_demo_home + '/examples/virtual_master_to_dut_slave'
        self.m_tb_name = 'Test_write_addr_after_write_data'

        self.runIUS()
        self.logIUS()
        self.assertEqual(self.reportIUS(), True)


    def test_phase_wite_addr_write_data_at_same_time(self):
        """ test AXI write addr and write data at the same time """

        self.m_tb_home = self.m_demo_home + '/examples/virtual_master_to_dut_slave'
        self.m_tb_name = 'Test_write_addr_write_data_at_same_time'

        self.runIUS()
        self.logIUS()
        self.assertEqual(self.reportIUS(), True)


    def test_phase_write_interleave_data(self):
        """ test AXI write interleave data """

        self.m_tb_home = self.m_demo_home + '/examples/virtual_master_to_dut_slave'
        self.m_tb_name = 'Test_write_interleave_data'

        self.runIUS()
        self.logIUS()
        self.assertEqual(self.reportIUS(), True)


def suite():
    suite = unittest.TestSuite()

    suite.addTest(TestAXIBFMVirtual('test_phase_write_data_after_write_addr'))
    suite.addTest(TestAXIBFMVirtual('test_phase_write_addr_after_write_data'))
    suite.addTest(TestAXIBFMVirtual('test_phase_write_out_of_performance'))
    suite.addTest(TestAXIBFMVirtual('test_phase_read_out_of_performance'))

    suite.addTest(TestAXIBFMDUT('test_phase_write_data_after_write_addr'))
    suite.addTest(TestAXIBFMDUT('test_phase_write_addr_after_write_data'))

    return suite

if __name__  == '__main__':
    runner = unittest.TextTestRunner()
    test_suite = suite()
    runner.run(test_suite)
