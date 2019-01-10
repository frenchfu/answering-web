package com.mkyong;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.springframework.util.StringUtils;

import com.google.common.collect.Lists;
import com.mkyong.model.QuestionUnit;

public class QuestionService {

	
	
	public List<QuestionUnit> scanQuectionExcelObject(InputStream sampleFile ) throws IOException{
		List<QuestionUnit> results = Lists.newArrayList();
		results.add(new QuestionUnit());
		
		POIFSFileSystem fs = new POIFSFileSystem(sampleFile);
		HSSFWorkbook wb = new HSSFWorkbook(fs);
		HSSFSheet sheet = wb.getSheetAt(0); // 取得Excel第一個sheet(從0開始)
		

		for(int i = 1 ; true ; i++) {
			
			QuestionUnit unit = new QuestionUnit();
			HSSFRow row = sheet.getRow(i);
			Cell cell = null;
			
			if(row == null || row.getCell(0) == null || StringUtils.isEmpty(row.getCell(0).getStringCellValue())) break;
			else unit.setQuestionText(row.getCell(0).getStringCellValue());
			unit.setId(i+"");
			for(int k =1 ; k < 5 ;k++ ) {
				cell = row.getCell(k);
				unit.getOptions().add(cell.getStringCellValue());
			}
			cell = row.getCell(5);
			BigDecimal answerIndex = new BigDecimal(cell.getNumericCellValue());
			unit.setAnswerIndex(answerIndex.intValue());
			results.add(unit);
			
		}
		
		try {
			wb.close();
			fs.close();
			sampleFile.close();
		}catch(Exception e) {
			e.printStackTrace();
		}

		
		return results;
	}
	
	
	
	
}
